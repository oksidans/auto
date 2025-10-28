<?php
declare(strict_types=1);

namespace Miki\Autoservis\Services;

use PDO;
use Miki\Autoservis\Models\Repositories\PdoAppointmentRepository;
use Miki\Autoservis\Models\Repositories\PdoInquiryRepository;
use Miki\Autoservis\Models\Domain\Appointment;

final class AppointmentService
{
    public function __construct(private PDO $pdo) {}

    /**
     * Konvertuj upit u termin: bira prvi slobodan slot (1 pa 2) za zadatog majstora i datum.
     * Ako nema slobodnog — baca izuzetak.
     * @return array{appointment_id:int, slot:int}  <-- vraćamo i slot da logovi budu informativniji
     */
    public function convertInquiryToAppointment(int $inquiryId, string $date, int $mechanicId, int $managerUserId): array
    {
        $inqRepo = new PdoInquiryRepository($this->pdo);
        $appRepo = new PdoAppointmentRepository($this->pdo);

        $inq = $inqRepo->findById($inquiryId);
        if (!$inq) {
            throw new \RuntimeException('Upit ne postoji.');
        }
        if (!in_array($inq->status(), ['new','contacted'], true)) {
            throw new \RuntimeException('Upit nije u statusu za konverziju.');
        }

        // 1) nađi ili kreiraj customer-a (po email/telefon)
        $customerId = $this->ensureCustomer($inq->customerName(), $inq->contactEmail(), $inq->contactPhone());

        // 2) izaberi slot (1 ili 2)
        $slot = $this->pickFreeSlot($appRepo, $mechanicId, $date);
        if ($slot === null) {
            throw new \RuntimeException('Nema slobodnih slotova za izabranog majstora na taj datum.');
        }

        // 3) kreiraj termin
        $appointment = new Appointment(
            id: null,
            date: $date,
            slot: $slot,
            mechanicId: $mechanicId,
            customerId: $customerId,
            vehicleId: null,
            status: 'approved'
        );

        $this->pdo->beginTransaction();
        try {
            $appId = $appRepo->create($appointment);

            // 4) markiraj inquiry kao konvertovan
            $inqRepo->markConverted($inquiryId, $appId);

            // 5) activity log (DB)
            (new ActivityLogger($this->pdo))->log(
                $managerUserId,
                'inquiry.convert',
                'inquiry',
                $inquiryId,
                ['appointment_id' => $appId, 'mechanic_id' => $mechanicId, 'date' => $date, 'slot' => $slot]
            );

            $this->pdo->commit();

            // Vraćamo i slot da controller može da upiše bogat file-log
            return ['appointment_id' => $appId, 'slot' => $slot];

        } catch (\Throwable $e) {
            $this->pdo->rollBack();
            throw $e;
        }
    }

    private function pickFreeSlot(PdoAppointmentRepository $repo, int $mechanicId, string $date): ?int
    {
        foreach ([1, 2] as $slot) {
            if (!$repo->existsSlot($mechanicId, $date, $slot)) {
                return $slot;
            }
        }
        return null;
    }

    private function ensureCustomer(string $name, ?string $email, ?string $phone): int
    {
        // VAŽNO: ne koristiti iste named parametre više puta (HY093)
        $sqlFind = "
            SELECT id FROM customers
            WHERE ((:e1 IS NOT NULL AND email = :e2)
               OR  (:p1 IS NOT NULL AND phone = :p2))
            LIMIT 1
        ";
        $st = $this->pdo->prepare($sqlFind);
        $st->execute([
            ':e1' => $email, ':e2' => $email,
            ':p1' => $phone, ':p2' => $phone,
        ]);
        $cid = $st->fetchColumn();
        if ($cid) return (int)$cid;

        $st = $this->pdo->prepare("INSERT INTO customers (name, email, phone) VALUES (:n, :e, :p)");
        $st->execute([':n' => $name, ':e' => $email, ':p' => $phone]);
        return (int)$this->pdo->lastInsertId();
    }
}
