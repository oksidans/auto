<?php
declare(strict_types=1);

namespace Miki\Autoservis\Models\Repositories;

use Miki\Autoservis\Models\Domain\Inquiry;

interface InquiryRepositoryInterface
{
    public function findById(int $id): ?Inquiry;

    /** Vrati listu upita po statusu (npr. 'new'), sa paginacijom. */
    public function listByStatus(string $status, int $limit = 20, int $offset = 0): array; // of Inquiry

    /** Kreira novi upit i vraća ID. */
    public function create(Inquiry $inquiry): int;

    /** Ažurira status (contacted/closed). */
    public function updateStatus(int $id, string $status): void;

    /** Obeleži upit kao konvertovan i veži appointment_id. */
    public function markConverted(int $id, int $appointmentId): void;
}
