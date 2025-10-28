<?php
declare(strict_types=1);

use Twig\Environment;
use Twig\Loader\FilesystemLoader;
use Twig\Extension\DebugExtension;

return static function (array $config): Environment {

    $viewsPath = __DIR__ . '/../src/Views';
    $loader = new FilesystemLoader($viewsPath);


    $twig = new Environment($loader, [
        'cache' => false,
        'debug' => (bool)($config['debug'] ?? false),
        'strict_variables' => false,
    ]);

    if (!empty($config['debug'])) {
        $twig->addExtension(new DebugExtension());
    }


    $loggedIn = isset($_SESSION['user_id']);
    $role     = $_SESSION['role'] ?? null;
    $email    = $_SESSION['email'] ?? null;

    $twig->addGlobal('logged_in', $loggedIn);
    $twig->addGlobal('role', $role);
    $twig->addGlobal('current_user_email', $email);


    if (isset($_GET['ok'])) {
        $twig->addGlobal('flash', $_GET['ok']);
    }

    return $twig;
};
