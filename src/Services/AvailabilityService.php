<?php
declare(strict_types=1);

namespace Miki\Autoservis\Services;

use PDO;

final class AvailabilityService
{
    public function __construct(private PDO $pdo) {}

    /**
     * Vrati listu majstora sa zauzetim i slobodnim slotovima za dati dan.
     * Svaki majstor ima max 2 slota dnevno.
     */
    public function forDate(\DateTimeInterface $date): array
    {
        $d = $date->format('Y-m-d');

        // Dohvati sve aktivne majstore
        $mechanics = $this->pdo->query(
            "SELECT id, alias FROM mechanics WHERE is_active = 1 ORDER BY alias"
        )->fetchAll();

        if (!$mechanics) return [];

        // Zauzeti slotovi po majstoru za dan D
        $stmt = $this->pdo->prepare(
            "SELECT mechanic_id, COUNT(id) AS taken
               FROM appointments
              WHERE date = :d
              GROUP BY mechanic_id"
        );
        $stmt->execute([':d' => $d]);
        $takenByMech = [];
        foreach ($stmt->fetchAll() as $row) {
            $takenByMech[(int)$row['mechanic_id']] = (int)$row['taken'];
        }

        // Sastavi rezultat
        $result = [];
        foreach ($mechanics as $m) {
            $taken = $takenByMech[(int)$m['id']] ?? 0;
            $free  = max(0, 2 - $taken);
            $result[] = [
                'mechanic_id' => (int)$m['id'],
                'alias'       => $m['alias'],
                'taken'       => $taken,
                'free'        => $free,
            ];
        }
        return $result;
    }
}
