<?php
declare(strict_types=1);

namespace Miki\Autoservis\Services;

use PDO;

final class ActivityLogger
{
    public function __construct(private PDO $pdo) {}


    public function log(?int $userId, string $action, ?string $entityType = null, ?int $entityId = null, array $details = []): void
    {
        try {
            $ip  = $_SERVER['REMOTE_ADDR']      ?? null;
            $ua  = $_SERVER['HTTP_USER_AGENT']  ?? null;
            $json = $details ? json_encode($details, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES) : null;

            $stmt = $this->pdo->prepare(
                "INSERT INTO activity_log (user_id, action, entity_type, entity_id, ip_address, user_agent, details)
                 VALUES (:u, :a, :et, :eid, :ip, :ua, :details)"
            );
            $stmt->execute([
                ':u' => $userId,
                ':a' => $action,
                ':et' => $entityType,
                ':eid' => $entityId,
                ':ip' => $ip,
                ':ua' => $ua,
                ':details' => $json,
            ]);
        } catch (\Throwable $e) {

        }
    }
}
