<?php
declare(strict_types=1);

namespace Miki\Autoservis\Models\Domain;

final class Inquiry
{
    public function __construct(
        private ?int $id,
        private string $dateRequested,              // 'Y-m-d'
        private string $customerName,
        private ?string $contactEmail,
        private ?string $contactPhone,
        private ?string $vehicleDesc,
        private ?int $preferredMechanicId,
        private string $status = 'new',             // new|contacted|converted|closed
        private ?string $createdAt = null,
        private ?int $convertedToAppointmentId = null,
    ) {
        $this->guard();
    }

    private function guard(): void
    {
        if ($this->customerName === '') {
            throw new \InvalidArgumentException('Ime klijenta je obavezno.');
        }
        if (($this->contactEmail === null || $this->contactEmail === '')
            && ($this->contactPhone === null || $this->contactPhone === '')) {
            throw new \InvalidArgumentException('Email ili telefon je obavezan.');
        }
        if (!in_array($this->status, ['new','contacted','converted','closed'], true)) {
            throw new \InvalidArgumentException('Status upita nije validan.');
        }
    }

    // Getteri
    public function id(): ?int { return $this->id; }
    public function dateRequested(): string { return $this->dateRequested; }
    public function customerName(): string { return $this->customerName; }
    public function contactEmail(): ?string { return $this->contactEmail; }
    public function contactPhone(): ?string { return $this->contactPhone; }
    public function vehicleDesc(): ?string { return $this->vehicleDesc; }
    public function preferredMechanicId(): ?int { return $this->preferredMechanicId; }
    public function status(): string { return $this->status; }
    public function createdAt(): ?string { return $this->createdAt; }
    public function convertedToAppointmentId(): ?int { return $this->convertedToAppointmentId; }

    // Mutacije unutar domena (kontrolisane)
    public function markContacted(): void { $this->status = 'contacted'; }
    public function markClosed(): void    { $this->status = 'closed'; }
    public function markConverted(int $appointmentId): void
    {
        $this->status = 'converted';
        $this->convertedToAppointmentId = $appointmentId;
    }

    // Mapiranja
    public static function fromArray(array $r): self
    {
        return new self(
            id: isset($r['id']) ? (int)$r['id'] : null,
            dateRequested: (string)$r['date_requested'],
            customerName:  (string)$r['customer_name'],
            contactEmail:  $r['contact_email'] ?? null,
            contactPhone:  $r['contact_phone'] ?? null,
            vehicleDesc:   $r['vehicle_desc'] ?? null,
            preferredMechanicId: isset($r['preferred_mechanic_id']) ? (int)$r['preferred_mechanic_id'] : null,
            status:        (string)$r['status'],
            createdAt:     $r['created_at'] ?? null,
            convertedToAppointmentId: isset($r['converted_to_appointment_id']) ? (int)$r['converted_to_appointment_id'] : null,
        );
    }

    public function toArray(): array
    {
        return [
            'id'                          => $this->id,
            'date_requested'              => $this->dateRequested,
            'customer_name'               => $this->customerName,
            'contact_email'               => $this->contactEmail,
            'contact_phone'               => $this->contactPhone,
            'vehicle_desc'                => $this->vehicleDesc,
            'preferred_mechanic_id'       => $this->preferredMechanicId,
            'status'                      => $this->status,
            'created_at'                  => $this->createdAt,
            'converted_to_appointment_id' => $this->convertedToAppointmentId,
        ];
    }
}
