<?php
declare(strict_types=1);

use Monolog\Level;
use Monolog\Logger;
use Monolog\Handler\RotatingFileHandler;
use Monolog\Formatter\LineFormatter;
use Monolog\Processor\UidProcessor;
use Monolog\Processor\WebProcessor;

return static function (array $config): Logger {
    if (!is_dir($config['paths']['logs'])) {
        @mkdir($config['paths']['logs'], 0775, true);
    }

    $logger = new Logger('Autoservis');


    $handler = new RotatingFileHandler(
        $config['paths']['logs'] . '/app.log',
        14,
        $config['debug'] ? Level::Debug : Level::Info,
        true,
        0664
    );


    $format = "[%datetime%] %channel%.%level_name%: %message% %context% %extra%\n";
    $formatter = new LineFormatter($format, "c", true, true);
    $handler->setFormatter($formatter);


    $logger->pushProcessor(new UidProcessor());
    $logger->pushProcessor(new WebProcessor());

    $logger->pushHandler($handler);

    return $logger;
};
