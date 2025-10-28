<?php
declare(strict_types=1);

use Miki\Autoservis\Controllers\GuestController;
use Miki\Autoservis\Controllers\AuthController;
use Miki\Autoservis\Controllers\ManagerController;
use Miki\Autoservis\Controllers\AdminController;

return [
    'GET' => [
        '/'                           => [GuestController::class, 'index'],


        '/login'                      => [AuthController::class, 'showLogin'],
        '/register'                   => [AuthController::class, 'showRegister'],
        '/health'                     => fn() => 'OK',


        '/manager/inquiries'          => [ManagerController::class, 'inquiries'],
        '/manager/convert'            => [ManagerController::class, 'showConvert'],


        '/admin/reports'              => [AdminController::class, 'reportsIndex'],
        '/admin/reports/inquiries'    => [AdminController::class, 'exportInquiries'],
        '/admin/reports/appointments' => [AdminController::class, 'exportAppointments'],
    ],
    'POST' => [
        '/inquiry'                    => [GuestController::class, 'sendInquiry'],
        '/login'                      => [AuthController::class, 'login'],
        '/register'                   => [AuthController::class, 'register'],
        '/logout'                     => [AuthController::class, 'logout'],

        '/manager/convert'            => [ManagerController::class, 'convert'],
    ],
];
