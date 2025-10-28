<?php
// public/router.php
$uri = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?? '/';
$file = __DIR__ . $uri;

// Ako postoji stvarni fajl (npr. /assets/app.css), prepusti ga serveru:
if ($uri !== '/' && is_file($file)) {
    return false;
}

// Sve dinamičko ide kroz front-controller:
require __DIR__ . '/index.php';
