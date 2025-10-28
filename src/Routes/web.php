<?php
use Miki\Autoservis\Controllers\GuestController;
use Miki\Autoservis\Controllers\AuthController;
use Miki\Autoservis\Controllers\ManagerController;
use Miki\Autoservis\Controllers\AdminController;

// Gost i korisnici
$routes['GET']['/']             = [GuestController::class, 'index'];
$routes['POST']['/inquiry']     = [GuestController::class, 'storeInquiry'];

// Autentifikacija
$routes['GET']['/login']        = [AuthController::class, 'showLogin'];
$routes['POST']['/login']       = [AuthController::class, 'login'];
$routes['GET']['/register']     = [AuthController::class, 'showRegister'];
$routes['POST']['/register']    = [AuthController::class, 'register'];
$routes['POST']['/logout']      = [AuthController::class, 'logout'];

// Menadžer
$routes['GET']['/manager/inquiries']        = [ManagerController::class, 'listInquiries'];
$routes['GET']['/manager/inquiries/convert'] = [ManagerController::class, 'showConvertForm'];
$routes['POST']['/manager/inquiries/convert'] = [ManagerController::class, 'convertInquiry'];

// Administrator
$routes['GET']['/admin/reports']                     = [AdminController::class, 'index'];
$routes['GET']['/admin/reports/inquiries']           = [AdminController::class, 'exportInquiries'];
$routes['GET']['/admin/reports/appointments']        = [AdminController::class, 'exportAppointments'];
