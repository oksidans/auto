<?php
declare(strict_types=1);

use Dotenv\Dotenv;

$root = dirname(__DIR__);
require $root . '/vendor/autoload.php';

$dotenv = Dotenv::createImmutable($root);
$dotenv->safeLoad();

$appEnv   = $_ENV['APP_ENV']   ?? 'local';
$appDebug = (bool)($_ENV['APP_DEBUG'] ?? 0);

if ($appDebug) {
    ini_set('display_errors', '1');
    error_reporting(E_ALL);
} else {
    ini_set('display_errors', '0');
    error_reporting(E_ALL & ~E_NOTICE & ~E_DEPRECATED & ~E_STRICT);
}

return [
    'root'      => $root,
    'env'       => $appEnv,
    'debug'     => $appDebug,
    'paths'     => [
        'views'  => $root . '/src/Views',
        'storage'=> $root . '/storage',
        'logs'   => $root . '/storage/logs',
        'cache'  => $root . '/storage/cache',
    ],
    'db' => [
        'host'      => $_ENV['DB_HOST'] ?? '127.0.0.1',
        'port'      => (int)($_ENV['DB_PORT'] ?? 3306),
        'name'      => $_ENV['DB_NAME'] ?? 'autoservis',
        'user'      => $_ENV['DB_USER'] ?? 'root',
        'pass'      => $_ENV['DB_PASS'] ?? '',
        'charset'   => $_ENV['DB_CHARSET'] ?? 'utf8mb4',
        'collation' => $_ENV['DB_COLLATION'] ?? 'utf8mb4_unicode_ci',
    ],
];
