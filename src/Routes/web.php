<?php
declare(strict_types=1);

use Miki\Autoservis\Controllers\GuestController;
use Miki\Autoservis\Controllers\AuthController;
use Miki\Autoservis\Controllers\ManagerController;
use Miki\Autoservis\Controllers\AdminController;

return [
    'GET' => [
        '/'                     => [GuestController::class, 'index'],
        '/login'                => [AuthController::class, 'showLogin'],
        '/register'             => [AuthController::class, 'showRegister'],
        '/health'               => fn() => 'OK',

        //Admin
        '/admin/reports'                 => [AdminController::class, 'reportsIndex'],
        '/admin/reports/inquiries.xlsx'  => [AdminController::class, 'exportInquiriesXlsx'],
        '/admin/reports/appointments.xlsx'=>[AdminController::class, 'exportAppointmentsXlsx'],
        '/admin/reports/inquiries.pdf'   => [AdminController::class, 'exportInquiriesPdf'],
        '/admin/reports/appointments.pdf'=> [AdminController::class, 'exportAppointmentsPdf'],        

        // manager
        '/manager/inquiries'    => [ManagerController::class, 'inquiries'],
        '/manager/convert'      => [ManagerController::class, 'showConvert'], // ?id=123
    ],
    'POST' => [
        '/inquiry'              => [GuestController::class, 'sendInquiry'],
        '/login'                => [AuthController::class, 'login'],
        '/register'             => [AuthController::class, 'register'],
        '/logout'               => [AuthController::class, 'logout'],

        // manager
        '/manager/convert'      => [ManagerController::class, 'convert'],
    ],
];
