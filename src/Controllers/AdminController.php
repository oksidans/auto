<?php
declare(strict_types=1);

namespace Miki\Autoservis\Controllers;

use Miki\Autoservis\Services\ReportService;
use Miki\Autoservis\Services\PdfService;
use Miki\Autoservis\Services\XlsxService;
use Twig\Environment;
use Monolog\Logger;
use PDO;

class AdminController
{
    private Environment $twig;
    private Logger $logger;
    private PDO $pdo;
    private ReportService $reportService;

    public function __construct(Environment $twig, Logger $logger, array $config, PDO $pdo)
    {
        $this->twig = $twig;
        $this->logger = $logger;
        $this->pdo = $pdo;
        $this->reportService = new ReportService($pdo);
    }

    public function index(): void
    {
        echo $this->twig->render('admin/reports.twig');
    }

    // ✅ NOVO: fleksibilni export za inquiries
    public function exportInquiries(): void
    {
        $format = strtolower($_GET['format'] ?? '');

        switch ($format) {
            case 'pdf':
                $this->exportInquiriesPdf();
                break;
            case 'xlsx':
                $this->exportInquiriesXlsx();
                break;
            default:
                http_response_code(400);
                echo 'Bad Request: missing or invalid format';
        }
    }

    // ✅ NOVO: fleksibilni export za appointments
    public function exportAppointments(): void
    {
        $format = strtolower($_GET['format'] ?? '');

        switch ($format) {
            case 'pdf':
                $this->exportAppointmentsPdf();
                break;
            case 'xlsx':
                $this->exportAppointmentsXlsx();
                break;
            default:
                http_response_code(400);
                echo 'Bad Request: missing or invalid format';
        }
    }

    // === PDF/XLSX izvozi postoje kao i ranije ===

    public function exportInquiriesPdf(): void
    {
        $data = $this->reportService->getAllInquiries();
        $pdf = new PdfService();
        $file = $pdf->generateInquiriesReport($data);
        $this->logger->info('Admin exported inquiries PDF', ['count' => count($data)]);
        $this->sendDownload($file, 'inquiries.pdf', 'application/pdf');
    }

    public function exportInquiriesXlsx(): void
    {
        $data = $this->reportService->getAllInquiries();
        $xlsx = new XlsxService();
        $file = $xlsx->generateInquiriesReport($data);
        $this->logger->info('Admin exported inquiries XLSX', ['count' => count($data)]);
        $this->sendDownload($file, 'inquiries.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    }

    public function exportAppointmentsPdf(): void
    {
        $data = $this->reportService->getAllAppointments();
        $pdf = new PdfService();
        $file = $pdf->generateAppointmentsReport($data);
        $this->logger->info('Admin exported appointments PDF', ['count' => count($data)]);
        $this->sendDownload($file, 'appointments.pdf', 'application/pdf');
    }

    public function exportAppointmentsXlsx(): void
    {
        $data = $this->reportService->getAllAppointments();
        $xlsx = new XlsxService();
        $file = $xlsx->generateAppointmentsReport($data);
        $this->logger->info('Admin exported appointments XLSX', ['count' => count($data)]);
        $this->sendDownload($file, 'appointments.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    }

    private function sendDownload(string $filePath, string $downloadName, string $mime): void
    {
        if (!is_file($filePath)) {
            http_response_code(404);
            echo "File not found: $downloadName";
            return;
        }

        header('Content-Description: File Transfer');
        header('Content-Type: ' . $mime);
        header('Content-Disposition: attachment; filename="' . $downloadName . '"');
        header('Content-Length: ' . filesize($filePath));
        readfile($filePath);
        unlink($filePath); // obriši temp fajl
    }
}
