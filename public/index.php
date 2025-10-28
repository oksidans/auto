<?php
declare(strict_types=1);
session_start();


$config = require __DIR__ . '/../config/app.php';


$makeTwig   = require __DIR__ . '/../config/twig.php';
$twig       = $makeTwig($config);

$makeLogger = require __DIR__ . '/../config/logger.php';
$logger     = $makeLogger($config);

$makePdo = require __DIR__ . '/../config/db.php';
$pdo     = $makePdo($config);


$routes = require __DIR__ . '/../src/Routes/web.php';


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


    if (is_array($handler)) {
        [$class, $action] = $handler;
        $controller = new $class($twig, $logger, $config, $pdo);
        echo $controller->$action();
        exit;
    }


    if (is_callable($handler)) {
        echo $handler();
        exit;
    }


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
