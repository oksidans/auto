<?php
declare(strict_types=1);

namespace Miki\Autoservis\Models\Repositories;

use PDO;
use Miki\Autoservis\Models\Domain\Appointment;

final class PdoAppointmentRepository implements AppointmentRepositoryInterface
{
    public function __construct(private PDO $pdo) {}

    public function findById(int $id): ?Appointment
    {
        $st = $this->pdo->prepare("SELECT * FROM appointments WHERE id=:id");
        $st->execute([':id'=>$id]);
        $row = $st->fetch();
        return $row ? Appointment::fromArray($row) : null;
    }

    public function countForMechanicDate(int $mechanicId, string $date): int
    {
        $st = $this->pdo->prepare("SELECT COUNT(*) c FROM appointments WHERE mechanic_id=:m AND date=:d");
        $st->execute([':m'=>$mechanicId, ':d'=>$date]);
        return (int)$st->fetchColumn();
    }

    public function existsSlot(int $mechanicId, string $date, int $slot): bool
    {
        $st = $this->pdo->prepare(
            "SELECT 1 FROM appointments WHERE mechanic_id=:m AND date=:d AND slot=:s LIMIT 1"
        );
        $st->execute([':m'=>$mechanicId, ':d'=>$date, ':s'=>$slot]);
        return (bool)$st->fetchColumn();
    }

    public function create(Appointment $a): int
    {
        $x = $a->toArray();
        $st = $this->pdo->prepare(
            "INSERT INTO appointments (date, slot, mechanic_id, customer_id, vehicle_id, status)
             VALUES (:d, :s, :m, :c, :v, :st)"
        );
        $st->execute([
            ':d'=>$x['date'], ':s'=>$x['slot'], ':m'=>$x['mechanic_id'],
            ':c'=>$x['customer_id'], ':v'=>$x['vehicle_id'], ':st'=>$x['status'],
        ]);
        return (int)$this->pdo->lastInsertId();
    }
}
