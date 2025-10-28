<?php
declare(strict_types=1);

namespace Miki\Autoservis\Models\Domain;

final class Appointment
{
    public function __construct(
        private ?int $id,
        private string $date,
        private int $slot,
        private int $mechanicId,
        private int $customerId,
        private ?int $vehicleId = null,
        private string $status = 'approved'
    ) {
        $this->guard();
    }

    private function guard(): void
    {
        if (!in_array($this->slot, [1,2], true)) {
            throw new \InvalidArgumentException('Slot mora biti 1 ili 2.');
        }
        if (!in_array($this->status, ['pending','approved','in_service','ready','closed'], true)) {
            throw new \InvalidArgumentException('Status termina nije validan.');
        }
        if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $this->date)) {
            throw new \InvalidArgumentException('Datum mora biti u formatu Y-m-d.');
        }
    }

    public function id(): ?int { return $this->id; }
    public function date(): string { return $this->date; }
    public function slot(): int { return $this->slot; }
    public function mechanicId(): int { return $this->mechanicId; }
    public function customerId(): int { return $this->customerId; }
    public function vehicleId(): ?int { return $this->vehicleId; }
    public function status(): string { return $this->status; }

    public static function fromArray(array $r): self
    {
        return new self(
            id: isset($r['id']) ? (int)$r['id'] : null,
            date: (string)$r['date'],
            slot: (int)$r['slot'],
            mechanicId: (int)$r['mechanic_id'],
            customerId: (int)$r['customer_id'],
            vehicleId: isset($r['vehicle_id']) ? (int)$r['vehicle_id'] : null,
            status: (string)$r['status']
        );
    }

    public function toArray(): array
    {
        return [
            'id'          => $this->id,
            'date'        => $this->date,
            'slot'        => $this->slot,
            'mechanic_id' => $this->mechanicId,
            'customer_id' => $this->customerId,
            'vehicle_id'  => $this->vehicleId,
            'status'      => $this->status,
        ];
    }
}
