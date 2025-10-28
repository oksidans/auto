<?php
declare(strict_types=1);

namespace Miki\Autoservis\Controllers;

use Twig\Environment;
use PDO;
use Miki\Autoservis\Services\LoggerService;
use Miki\Autoservis\Services\ActivityLogger;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use Mpdf\Mpdf;

final class AdminController
{
    private LoggerService $log;
    private ActivityLogger $activity;

    public function __construct(
        private Environment $twig,
        private \Monolog\Logger $logger,
        private array $config,
        private PDO $pdo
    ) {
        $this->log = new LoggerService($this->logger);
        $this->activity = new ActivityLogger($this->pdo);
    }

    private function ensureAdmin(): void
    {
        if (!isset($_SESSION['user_id'], $_SESSION['role']) || $_SESSION['role'] !== 'admin') {
            http_response_code(403);
            echo '403 Forbidden';
            exit;
        }
    }

    public function reportsIndex(): string
    {
        $this->ensureAdmin();

        return $this->twig->render('admin/reports.twig', [
            'today' => (new \DateTimeImmutable('today'))->format('Y-m-d'),
        ]);
    }

    // ============ XLSX EXPORT ============

    public function exportInquiriesXlsx(): void
    {
        $this->ensureAdmin();

        $rows = $this->pdo->query("
            SELECT id, date_requested, customer_name, contact_email, contact_phone,
                   vehicle_desc, preferred_mechanic_id, status, created_at
            FROM inquiries
            ORDER BY created_at DESC
            LIMIT 1000
        ")->fetchAll(PDO::FETCH_ASSOC);

        $spreadsheet = new Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();
        $sheet->setTitle('Inquiries');


        $headers = ['ID', 'Date Requested', 'Customer', 'Email', 'Phone', 'Vehicle', 'Preferred Mechanic ID', 'Status', 'Created At'];
        $sheet->fromArray($headers, null, 'A1');


        $r = 2;
        foreach ($rows as $row) {
            $sheet->fromArray([
                $row['id'],
                $row['date_requested'],
                $row['customer_name'],
                $row['contact_email'],
                $row['contact_phone'],
                $row['vehicle_desc'],
                $row['preferred_mechanic_id'],
                $row['status'],
                $row['created_at'],
            ], null, 'A' . $r);
            $r++;
        }


        foreach (range('A', 'I') as $col) {
            $sheet->getColumnDimension($col)->setAutoSize(true);
        }

        $filename = 'inquiries-' . date('Ymd-His') . '.xlsx';
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        header('Cache-Control: max-age=0');

        $writer = new Xlsx($spreadsheet);
        $writer->save('php://output');

        // log
        $this->activity->log((int)$_SESSION['user_id'], 'report.export', 'inquiries', null, ['format' => 'xlsx']);
        $this->log->inquiryCreated(0, null);
        exit;
    }

    public function exportAppointmentsXlsx(): void
    {
        $this->ensureAdmin();

        $rows = $this->pdo->query("
            SELECT a.id, a.date, a.slot, a.status,
                   m.alias AS mechanic, c.name AS customer, v.plate_number, v.make, v.model
            FROM appointments a
            JOIN mechanics m ON m.id = a.mechanic_id
            JOIN customers c ON c.id = a.customer_id
            LEFT JOIN vehicles v ON v.id = a.vehicle_id
            ORDER BY a.date DESC, a.id DESC
            LIMIT 2000
        ")->fetchAll(PDO::FETCH_ASSOC);

        $spreadsheet = new Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();
        $sheet->setTitle('Appointments');

        $headers = ['ID', 'Date', 'Slot', 'Mechanic', 'Customer', 'Plate', 'Make', 'Model', 'Status'];
        $sheet->fromArray($headers, null, 'A1');

        $r = 2;
        foreach ($rows as $row) {
            $sheet->fromArray([
                $row['id'],
                $row['date'],
                $row['slot'],
                $row['mechanic'],
                $row['customer'],
                $row['plate_number'],
                $row['make'],
                $row['model'],
                $row['status'],
            ], null, 'A' . $r);
            $r++;
        }

        foreach (range('A', 'I') as $col) {
            $sheet->getColumnDimension($col)->setAutoSize(true);
        }

        $filename = 'appointments-' . date('Ymd-His') . '.xlsx';
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        header('Cache-Control: max-age=0');

        $writer = new Xlsx($spreadsheet);
        $writer->save('php://output');

        $this->activity->log((int)$_SESSION['user_id'], 'report.export', 'appointments', null, ['format' => 'xlsx']);
        exit;
    }

    // ============ PDF EXPORT ============

    public function exportInquiriesPdf(): void
    {
        $this->ensureAdmin();

        $rows = $this->pdo->query("
            SELECT id, date_requested, customer_name, contact_email, contact_phone,
                   vehicle_desc, preferred_mechanic_id, status, created_at
            FROM inquiries
            ORDER BY created_at DESC
            LIMIT 1000
        ")->fetchAll(PDO::FETCH_ASSOC);

        $html = '<h2>Inquiries</h2><table width="100%" border="1" cellspacing="0" cellpadding="4">
            <thead><tr>
              <th>ID</th><th>Date</th><th>Customer</th><th>Email</th><th>Phone</th><th>Vehicle</th><th>Pref. Mechanic</th><th>Status</th><th>Created</th>
            </tr></thead><tbody>';

        foreach ($rows as $r) {
            $html .= '<tr>'.
              '<td>'.htmlspecialchars((string)$r['id']).'</td>'.
              '<td>'.htmlspecialchars((string)$r['date_requested']).'</td>'.
              '<td>'.htmlspecialchars((string)$r['customer_name']).'</td>'.
              '<td>'.htmlspecialchars((string)($r['contact_email'] ?? '')).'</td>'.
              '<td>'.htmlspecialchars((string)($r['contact_phone'] ?? '')).'</td>'.
              '<td>'.htmlspecialchars((string)($r['vehicle_desc'] ?? '')).'</td>'.
              '<td>'.htmlspecialchars((string)($r['preferred_mechanic_id'] ?? '')).'</td>'.
              '<td>'.htmlspecialchars((string)$r['status']).'</td>'.
              '<td>'.htmlspecialchars((string)$r['created_at']).'</td>'.
            '</tr>';
        }
        $html .= '</tbody></table>';

        $mpdf = new Mpdf(['tempDir' => sys_get_temp_dir()]);
        $mpdf->WriteHTML($html);
        $filename = 'inquiries-' . date('Ymd-His') . '.pdf';
        $mpdf->Output($filename, 'D');

        $this->activity->log((int)$_SESSION['user_id'], 'report.export', 'inquiries', null, ['format' => 'pdf']);
        exit;
    }

    public function exportAppointmentsPdf(): void
    {
        $this->ensureAdmin();

        $rows = $this->pdo->query("
            SELECT a.id, a.date, a.slot, a.status,
                   m.alias AS mechanic, c.name AS customer, v.plate_number, v.make, v.model
            FROM appointments a
            JOIN mechanics m ON m.id = a.mechanic_id
            JOIN customers c ON c.id = a.customer_id
            LEFT JOIN vehicles v ON v.id = a.vehicle_id
            ORDER BY a.date DESC, a.id DESC
            LIMIT 2000
        ")->fetchAll(PDO::FETCH_ASSOC);

        $html = '<h2>Appointments</h2><table width="100%" border="1" cellspacing="0" cellpadding="4">
            <thead><tr>
              <th>ID</th><th>Date</th><th>Slot</th><th>Mechanic</th><th>Customer</th><th>Plate</th><th>Make</th><th>Model</th><th>Status</th>
            </tr></thead><tbody>';

        foreach ($rows as $r) {
            $html .= '<tr>'.
              '<td>'.htmlspecialchars((string)$r['id']).'</td>'.
              '<td>'.htmlspecialchars((string)$r['date']).'</td>'.
              '<td>'.htmlspecialchars((string)$r['slot']).'</td>'.
              '<td>'.htmlspecialchars((string)$r['mechanic']).'</td>'.
              '<td>'.htmlspecialchars((string)$r['customer']).'</td>'.
              '<td>'.htmlspecialchars((string)($r['plate_number'] ?? '')).'</td>'.
              '<td>'.htmlspecialchars((string)($r['make'] ?? '')).'</td>'.
              '<td>'.htmlspecialchars((string)($r['model'] ?? '')).'</td>'.
              '<td>'.htmlspecialchars((string)$r['status']).'</td>'.
            '</tr>';
        }
        $html .= '</tbody></table>';

        $mpdf = new Mpdf(['tempDir' => sys_get_temp_dir()]);
        $mpdf->WriteHTML($html);
        $filename = 'appointments-' . date('Ymd-His') . '.pdf';
        $mpdf->Output($filename, 'D');

        $this->activity->log((int)$_SESSION['user_id'], 'report.export', 'appointments', null, ['format' => 'pdf']);
        exit;
    }
}
