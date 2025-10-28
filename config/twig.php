<?php
declare(strict_types=1);

use Twig\Environment;
use Twig\Loader\FilesystemLoader;

return static function (array $config): Environment {
    $loader = new FilesystemLoader($config['paths']['views']);

    $twig = new Environment($loader, [
        'cache' => false, // za prod: $config['paths']['cache']
        'debug' => $config['debug'],
        'autoescape' => 'html',
    ]);

    if ($config['debug']) {
        $twig->enableDebug();
    }

    // globalne promenljive, po želji
    $twig->addGlobal('app_env', $config['env']);

    return $twig;
};
