<?php
declare(strict_types=1);
session_start();

// 1) Konfig i autoload
$config = require __DIR__ . '/../config/app.php';

// 2) Servisi (Twig, Logger, PDO)
$makeTwig   = require __DIR__ . '/../config/twig.php';
$twig       = $makeTwig($config);

$makeLogger = require __DIR__ . '/../config/logger.php';
$logger     = $makeLogger($config);

$makePdo = require __DIR__ . '/../config/db.php';
$pdo     = $makePdo($config);

// 3) Učitaj rute
$routes = require __DIR__ . '/../src/Routes/web.php';

// 4) Minimalni dispatcher
[$method, $uri] = [
    $_SERVER['REQUEST_METHOD'] ?? 'GET',
    rtrim(parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?? '/', '/') ?: '/'
];

$handler = $routes[$method][$uri] ?? null;

try {
    if (!$handler) {
        http_response_code(404);
        echo '404 Not Found';
        $logger->warning('Route not found', ['method' => $method, 'uri' => $uri]);
        exit;
    }

    // [Class, method]
    if (is_array($handler)) {
        [$class, $action] = $handler;
        $controller = new $class($twig, $logger, $config, $pdo); // inject $pdo
        echo $controller->$action();
        exit;
    }

    // Closure / callable bez argumenata (npr. /health)
    if (is_callable($handler)) {
        echo $handler(); // ne prosleđujemo parametre da izbegnemo ArgumentCountError
        exit;
    }

    // Ako je došlo do nečeg neočekivanog:
    http_response_code(500);
    echo '500 Server Error';
    $logger->error('Invalid route handler type', ['handler' => gettype($handler)]);
} catch (\Throwable $e) {
    http_response_code(500);
    $logger->error('Unhandled exception', [
        'error' => $e->getMessage(),
        'trace' => $e->getTraceAsString(),
    ]);
    echo $config['debug'] ? ('<pre>' . htmlspecialchars((string)$e) . '</pre>') : '500 Server Error';
}
