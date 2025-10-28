<?php
declare(strict_types=1);

namespace Miki\Autoservis\Services;

use Monolog\Logger;

final class LoggerService
{
    public function __construct(private Logger $logger) {}

    public function loginSuccess(string $email, int $userId): void
    {
        $this->logger->info('User ' . $email . ' successfully logged in', ['user_id' => $userId]);
    }

    public function loginFailed(string $email): void
    {
        $this->logger->warning('User login failed', ['email' => $email]);
    }

    public function logout(string $email, int $userId): void
    {
        $this->logger->info('User signed out', ['email' => $email, 'user_id' => $userId]);
    }

    public function inquiryCreated(int $inquiryId, ?int $preferredMechanicId): void
    {
        $this->logger->info('Inquiry created', [
            'inquiry_id' => $inquiryId,
            'preferred_mechanic_id' => $preferredMechanicId,
        ]);
    }

    public function inquiryConverted(int $inquiryId, int $appointmentId, int $mechanicId, string $date, int $slot): void
    {
        $this->logger->info('Inquiry converted to appointment', [
            'inquiry_id' => $inquiryId,
            'appointment_id' => $appointmentId,
            'mechanic_id' => $mechanicId,
            'date' => $date,
            'slot' => $slot,
        ]);
    }
}
