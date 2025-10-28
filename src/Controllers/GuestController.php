<?php
declare(strict_types=1);

namespace Miki\Autoservis\Controllers;

use Twig\Environment;
use PDO;
use Miki\Autoservis\Services\AvailabilityService;
use Miki\Autoservis\Services\ActivityLogger;
use Miki\Autoservis\Services\LoggerService;

final class GuestController
{
    private ?ActivityLogger $activity = null;
    private LoggerService $log;

    public function __construct(
        private Environment $twig,
        private \Monolog\Logger $logger,
        private array $config,
        private ?PDO $pdo = null
    ) {
        if ($this->pdo) {
            $this->activity = new ActivityLogger($this->pdo);
        }
        $this->log = new LoggerService($this->logger);
    }

    public function index(): string
    {
        $today = new \DateTimeImmutable('today');


        $availability = [];
        if ($this->pdo) {
            $availability = (new AvailabilityService($this->pdo))->forDate($today);
        }


        $mechanicsForSelect = [];
        if ($this->pdo) {
            $withFree = array_filter($availability, fn($r) => (int)($r['free'] ?? 0) > 0);
            $source = $withFree ?: $availability;
            foreach ($source as $row) {
                $mechanicsForSelect[] = [
                    'id'    => (int)$row['mechanic_id'],
                    'alias' => (string)$row['alias'],
                    'free'  => (int)$row['free'],
                ];
            }
        }

        $loggedIn = isset($_SESSION['user_id']);
        $role = $_SESSION['role'] ?? null;


        $csrf = null;
        if ($loggedIn && $role === 'user') {
            $csrf = bin2hex(random_bytes(32));
            $_SESSION['csrf'] = $csrf;
        }

        return $this->twig->render('guest/home.twig', [
            'today'        => $today->format('Y-m-d'),
            'availability' => $availability,
            'mechanics'    => $mechanicsForSelect,
            'logged_in'    => $loggedIn,
            'role'         => $role,
            'csrf'         => $csrf,
            'flash'        => $_GET['ok'] ?? null,
            'errors'       => [],
            'old'          => [],
        ]);
    }

    public function sendInquiry(): void
    {

        if (!isset($_SESSION['user_id']) || ($_SESSION['role'] ?? null) !== 'user') {
            header('Location: /?ok=Za%20slanje%20upita%20potreban%20je%20korisni%C4%8Dki%20nalog.');
            exit;
        }


        $ok = isset($_POST['csrf'], $_SESSION['csrf']) && hash_equals($_SESSION['csrf'], $_POST['csrf']);
        unset($_SESSION['csrf']);
        if (!$ok) {
            http_response_code(400);
            echo 'Bad request (CSRF).';
            return;
        }

        $today = (new \DateTimeImmutable('today'))->format('Y-m-d');

        $name   = trim($_POST['name']    ?? '');
        $email  = trim($_POST['email']   ?? '');
        $phone  = trim($_POST['phone']   ?? '');
        $veh    = trim($_POST['vehicle'] ?? '');
        $notes  = trim($_POST['notes']   ?? '');
        $mechId = isset($_POST['mechanic_id']) ? (int)$_POST['mechanic_id'] : 0;

        $errors = [];
        if ($name === '')  { $errors['name'] = 'Ime je obavezno.'; }
        if ($email === '' && $phone === '') { $errors['contact'] = 'Email ili telefon je obavezan.'; }
        if ($mechId <= 0) { $errors['mechanic'] = 'Izaberite majstora.'; }


        if (!$errors && $this->pdo) {
            $st = $this->pdo->prepare('SELECT id FROM mechanics WHERE id = :id AND is_active = 1 LIMIT 1');
            $st->execute([':id' => $mechId]);
            if (!$st->fetch()) {
                $errors['mechanic'] = 'Izabrani majstor ne postoji ili nije aktivan.';
            }
        }

        if ($errors) {

            $availability = $this->pdo ? (new AvailabilityService($this->pdo))->forDate(new \DateTimeImmutable('today')) : [];
            $withFree = array_filter($availability, fn($r) => (int)($r['free'] ?? 0) > 0);
            $source = $withFree ?: $availability;
            $mechanics = array_map(
                fn($r) => ['id' => (int)$r['mechanic_id'], 'alias' => $r['alias'], 'free' => (int)$r['free']],
                $source
            );

            $csrf = bin2hex(random_bytes(32));
            $_SESSION['csrf'] = $csrf;

            echo $this->twig->render('guest/home.twig', [
                'today'        => $today,
                'availability' => $availability,
                'mechanics'    => $mechanics,
                'logged_in'    => true,
                'role'         => 'user',
                'csrf'         => $csrf,
                'errors'       => $errors,
                'old'          => [
                    'name' => $name, 'email' => $email, 'phone' => $phone,
                    'veh'  => $veh,  'notes' => $notes, 'mechanic_id' => $mechId
                ],
            ]);
            return;
        }


        if ($this->pdo) {
            $st = $this->pdo->prepare(
                'INSERT INTO inquiries
                 (date_requested, customer_name, contact_email, contact_phone, vehicle_desc, preferred_mechanic_id, notes)
                 VALUES (:d, :n, :e, :p, :v, :m, :t)'
            );
            $st->execute([
                ':d' => $today,
                ':n' => $name,
                ':e' => $email ?: null,
                ':p' => $phone ?: null,
                ':v' => $veh   ?: null,
                ':m' => $mechId ?: null,
                ':t' => $notes ?: null,
            ]);

            $inqId = (int)$this->pdo->lastInsertId();


            $this->activity?->log(
                $_SESSION['user_id'] ?? null,
                'inquiry.create',
                'inquiry',
                $inqId,
                ['preferred_mechanic_id' => $mechId]
            );


            $this->log->inquiryCreated($inqId, $mechId);
        }


        header('Location: /?ok=Hvala%20na%20upitu!%20Javi%C4%87emo%20Vam%20se%20uskoro.');
        exit;
    }
}
