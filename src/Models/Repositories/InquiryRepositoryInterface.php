<?php
declare(strict_types=1);

namespace Miki\Autoservis\Models\Repositories;

use Miki\Autoservis\Models\Domain\Inquiry;

interface InquiryRepositoryInterface
{
    public function findById(int $id): ?Inquiry;


    public function listByStatus(string $status, int $limit = 20, int $offset = 0): array;


    public function create(Inquiry $inquiry): int;


    public function updateStatus(int $id, string $status): void;


    public function markConverted(int $id, int $appointmentId): void;
}
