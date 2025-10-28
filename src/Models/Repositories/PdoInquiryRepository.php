<?php
declare(strict_types=1);

namespace Miki\Autoservis\Models\Repositories;

use PDO;
use Miki\Autoservis\Models\Domain\Inquiry;

final class PdoInquiryRepository implements InquiryRepositoryInterface
{
    public function __construct(private PDO $pdo) {}

    public function findById(int $id): ?Inquiry
    {
        $st = $this->pdo->prepare("SELECT * FROM inquiries WHERE id=:id LIMIT 1");
        $st->execute([':id' => $id]);
        $row = $st->fetch();
        return $row ? Inquiry::fromArray($row) : null;
    }

    public function listByStatus(string $status, int $limit = 20, int $offset = 0): array
    {
        $st = $this->pdo->prepare(
            "SELECT * FROM inquiries WHERE status=:s ORDER BY created_at DESC LIMIT :lim OFFSET :off"
        );
        $st->bindValue(':s', $status, PDO::PARAM_STR);
        $st->bindValue(':lim', $limit, PDO::PARAM_INT);
        $st->bindValue(':off', $offset, PDO::PARAM_INT);
        $st->execute();

        $out = [];
        while ($row = $st->fetch()) {
            $out[] = Inquiry::fromArray($row);
        }
        return $out;
    }

    public function create(Inquiry $inq): int
    {
        $a = $inq->toArray();
        $st = $this->pdo->prepare(
            "INSERT INTO inquiries
             (date_requested, customer_name, contact_email, contact_phone, vehicle_desc, preferred_mechanic_id, notes, status)
             VALUES (:d, :n, :e, :p, :v, :m, :t, :s)"
        );
        $st->execute([
            ':d' => $a['date_requested'],
            ':n' => $a['customer_name'],
            ':e' => $a['contact_email'],
            ':p' => $a['contact_phone'],
            ':v' => $a['vehicle_desc'],
            ':m' => $a['preferred_mechanic_id'],
            ':t' => $a['notes'] ?? null,
            ':s' => $a['status'] ?? 'new',
        ]);
        return (int)$this->pdo->lastInsertId();
    }

    public function updateStatus(int $id, string $status): void
    {
        if (!in_array($status, ['new','contacted','converted','closed'], true)) {
            throw new \InvalidArgumentException('Status nije validan.');
        }
        $st = $this->pdo->prepare("UPDATE inquiries SET status=:s WHERE id=:id");
        $st->execute([':s' => $status, ':id' => $id]);
    }

    public function markConverted(int $id, int $appointmentId): void
    {
        $st = $this->pdo->prepare(
            "UPDATE inquiries
                SET status='converted', converted_to_appointment_id=:aid
              WHERE id=:id"
        );
        $st->execute([':aid' => $appointmentId, ':id' => $id]);
    }
}
