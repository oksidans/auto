<?php
declare(strict_types=1);

namespace Miki\Autoservis\Controllers;

use Twig\Environment;
use PDO;
use Miki\Autoservis\Services\LoggerService;
use Miki\Autoservis\Services\ActivityLogger;

final class AuthController
{
    private ActivityLogger $activity;
    private LoggerService $log;

    public function __construct(
        private Environment $twig,
        private \Monolog\Logger $logger,
        private array $config,
        private PDO $pdo
    ) {
        $this->activity = new ActivityLogger($this->pdo);
        $this->log = new LoggerService($this->logger);
    }


    public function showLogin(): string
    {

        $csrf = bin2hex(random_bytes(32));
        $_SESSION['csrf'] = $csrf;


        $next = $_GET['next'] ?? '/';

        return $this->twig->render('auth/login.twig', [
            'csrf'   => $csrf,
            'next'   => $next,
            'errors' => [],
            'old'    => ['email' => ''],
            'success'=> $_GET['success'] ?? null,
        ]);
    }


    public function login(): void
    {

        $ok = isset($_POST['csrf'], $_SESSION['csrf']) && hash_equals($_SESSION['csrf'], $_POST['csrf']);
        unset($_SESSION['csrf']);
        if (!$ok) {
            http_response_code(400);
            echo 'Bad request (CSRF).';
            return;
        }

        $email = trim($_POST['email'] ?? '');
        $password = $_POST['password'] ?? '';
        $next = $_POST['next'] ?? '/';

        $errors = [];

        if ($email === '' || $password === '') {
            $errors['login'] = 'Email i lozinka su obavezni.';
            echo $this->twig->render('auth/login.twig', [
                'csrf'   => bin2hex(random_bytes(32)),
                'next'   => $next,
                'errors' => $errors,
                'old'    => ['email' => $email],
            ]);
            return;
        }

        $stmt = $this->pdo->prepare('SELECT * FROM users WHERE email = :email AND is_active = 1');
        $stmt->execute(['email' => $email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user || !password_verify($password, $user['password_hash'])) {
            $this->log->loginFailed($email);
            $errors['login'] = 'Pogrešan email ili lozinka.';
            echo $this->twig->render('auth/login.twig', [
                'csrf'   => bin2hex(random_bytes(32)),
                'next'   => $next,
                'errors' => $errors,
                'old'    => ['email' => $email],
            ]);
            return;
        }


        session_regenerate_id(true);
        $_SESSION['user_id'] = (int)$user['id'];
        $_SESSION['role']    = $user['role'];
        $_SESSION['email']   = $user['email'];

        $this->activity->log((int)$user['id'], 'auth.login', 'user', (int)$user['id']);
        $this->log->loginSuccess($user['email'], (int)$user['id']);

        header('Location: ' . ($next ?: '/'));
        exit;
    }


    public function showRegister(): string
    {
        $csrf = bin2hex(random_bytes(32));
        $_SESSION['csrf'] = $csrf;

        return $this->twig->render('auth/register.twig', [
            'csrf'   => $csrf,
            'errors' => [],
            'old'    => ['full_name' => '', 'email' => ''],
        ]);
    }


    public function register(): void
    {

        $ok = isset($_POST['csrf'], $_SESSION['csrf']) && hash_equals($_SESSION['csrf'], $_POST['csrf']);
        unset($_SESSION['csrf']);
        if (!$ok) {
            http_response_code(400);
            echo 'Bad request (CSRF).';
            return;
        }


        $fullName = trim($_POST['full_name'] ?? '');
        $email    = trim($_POST['email'] ?? '');
        $pass     = $_POST['password'] ?? '';
        $pass2    = $_POST['password_confirm'] ?? '';

        $errors = [];
        if ($fullName === '') { $errors['full_name'] = 'Ime i prezime je obavezno.'; }
        if ($email === '')    { $errors['email']     = 'Email je obavezan.'; }
        if ($pass === '')     { $errors['password']  = 'Lozinka je obavezna.'; }
        if ($pass !== $pass2) { $errors['password_confirm'] = 'Lozinke se ne poklapaju.'; }


        if (!$errors) {
            $stmt = $this->pdo->prepare('SELECT id FROM users WHERE email = :email LIMIT 1');
            $stmt->execute(['email' => $email]);
            if ($stmt->fetch()) {
                $errors['email'] = 'Email već postoji.';
            }
        }

        if ($errors) {

            $csrf = bin2hex(random_bytes(32));
            $_SESSION['csrf'] = $csrf;
            echo $this->twig->render('auth/register.twig', [
                'csrf'   => $csrf,
                'errors' => $errors,
                'old'    => ['full_name' => $fullName, 'email' => $email],
            ]);
            return;
        }

        $hash = password_hash($pass, PASSWORD_BCRYPT);
        $stmt = $this->pdo->prepare(
            'INSERT INTO users (email, password_hash, role, full_name) VALUES (:email, :pass, "user", :name)'
        );
        $stmt->execute([
            'email' => $email,
            'pass'  => $hash,
            'name'  => $fullName,
        ]);


        header('Location: /login?success=Registracija%20uspe%C5%A1na%2C%20prijavite%20se.');
        exit;
    }

    public function logout(): void
    {
        $uid   = $_SESSION['user_id'] ?? null;
        $email = $_SESSION['email'] ?? 'unknown';

        if ($uid !== null) {
            $this->activity->log((int)$uid, 'auth.logout', 'user', (int)$uid);
            $this->log->logout($email, (int)$uid);
        }

        session_unset();
        session_destroy();

        header('Location: /?ok=Odjavljeni%20ste.');
        exit;
    }
}
