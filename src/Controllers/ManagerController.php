<?php
declare(strict_types=1);

namespace Miki\Autoservis\Controllers;

use Twig\Environment;
use PDO;
use Miki\Autoservis\Models\Repositories\PdoInquiryRepository;
use Miki\Autoservis\Services\AppointmentService;
use Miki\Autoservis\Services\LoggerService;

final class ManagerController
{
    private LoggerService $log;

    public function __construct(
        private Environment $twig,
        private \Monolog\Logger $logger,
        private array $config,
        private PDO $pdo
    ) {
        $this->log = new LoggerService($this->logger);
    }

    private function ensureManager(): void
    {
        if (!isset($_SESSION['user_id'], $_SESSION['role']) || $_SESSION['role'] !== 'manager') {
            http_response_code(403);
            echo '403 Forbidden';
            exit;
        }
    }

    public function inquiries(): string
    {
        $this->ensureManager();

        $repo = new PdoInquiryRepository($this->pdo);
        $items = $repo->listByStatus('new', 50, 0);

        // (opciono) mapa ID->alias za prikaz u listi
        $mechMap = [];
        foreach ($this->pdo->query('SELECT id, alias FROM mechanics WHERE is_active=1') as $row) {
            $mechMap[(int)$row['id']] = $row['alias'];
        }

        return $this->twig->render('manager/inquiries_list.twig', [
            'items'   => $items,
            'flash'   => $_GET['ok'] ?? null,
            'mechMap' => $mechMap,
        ]);
    }

    public function showConvert(): string
    {
        $this->ensureManager();

        $id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
        $repo = new PdoInquiryRepository($this->pdo);
        $inq = $repo->findById($id);
        if (!$inq) {
            http_response_code(404);
            return 'Upit nije pronađen.';
        }

        $mechs = $this->pdo
            ->query('SELECT id, alias FROM mechanics WHERE is_active=1 ORDER BY alias')
            ->fetchAll();

        $csrf = bin2hex(random_bytes(32));
        $_SESSION['csrf'] = $csrf;

        return $this->twig->render('manager/inquiry_convert.twig', [
            'inq'       => $inq,
            'mechanics' => $mechs,
            'csrf'      => $csrf,
            'today'     => (new \DateTimeImmutable('today'))->format('Y-m-d'),
        ]);
    }

    public function convert(): void
    {
        $this->ensureManager();

        // CSRF
        $ok = isset($_POST['csrf'], $_SESSION['csrf']) && hash_equals($_SESSION['csrf'], $_POST['csrf']);
        unset($_SESSION['csrf']);
        if (!$ok) {
            http_response_code(400);
            echo 'Bad request (CSRF).';
            return;
        }

        $inquiryId  = (int)($_POST['inquiry_id'] ?? 0);
        $mechanicId = (int)($_POST['mechanic_id'] ?? 0);
        $date       = trim($_POST['date'] ?? '');

        if ($inquiryId <= 0 || $mechanicId <= 0 || !preg_match('/^\d{4}-\d{2}-\d{2}$/', $date)) {
            http_response_code(422);
            echo 'Neispravni podaci.';
            return;
        }

        try {
            $service = new AppointmentService($this->pdo);
            $res = $service->convertInquiryToAppointment($inquiryId, $date, $mechanicId, (int)$_SESSION['user_id']);

            // File log (Monolog) — sada imamo i slot
            $this->log->inquiryConverted(
                $inquiryId,
                $res['appointment_id'],
                $mechanicId,
                $date,
                $res['slot']
            );

            header('Location: /manager/inquiries?ok=Upit%20je%20konvertovan%20u%20termin.');
            exit;
        } catch (\Throwable $e) {
            http_response_code(400);
            echo 'Greška: ' . htmlspecialchars($e->getMessage());
        }
    }
}
