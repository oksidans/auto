<?php
declare(strict_types=1);

namespace Miki\Autoservis\Models\Repositories;

use Miki\Autoservis\Models\Domain\Appointment;

interface AppointmentRepositoryInterface
{
    public function findById(int $id): ?Appointment;
    public function countForMechanicDate(int $mechanicId, string $date): int; // koliko je zauzeto
    public function existsSlot(int $mechanicId, string $date, int $slot): bool;
    public function create(Appointment $appointment): int; // vraća ID
}
