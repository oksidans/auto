<?php
declare(strict_types=1);

namespace Miki\Autoservis\Controllers;

use PDO;
use Twig\Environment as Twig;
use Monolog\Logger;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use Mpdf\Mpdf;

class AdminController
{
    public function __construct(
        private Twig $twig,
        private Logger $logger,
        private array $config,
        private PDO $pdo
    ) {}

    public function reportsIndex(): string
    {
        // Prikaži linkove na exporte:
        // /admin/reports/inquiries?format=pdf|xlsx
        // /admin/reports/appointments?format=pdf|xlsx
        return $this->twig->render('admin/reports.twig', []);
    }

    public function exportInquiries(): string
    {
        $format = strtolower($_GET['format'] ?? '');
        $rows = $this->fetchInquiries();

        if ($format === 'xlsx') {
            $this->outputXlsx('inquiries', ['ID','Datum','Ime','Email','Telefon','Vozilo','Napomena','Status'], $rows);
            return '';
        }
        if ($format === 'pdf') {
            $this->outputPdf('Inquiries', ['ID','Datum','Ime','Email','Telefon','Vozilo','Napomena','Status'], $rows);
            return '';
        }

        // Ako nema format parametra, vrati UI stranu ili 400
        http_response_code(400);
        return 'Bad Request: missing format (pdf|xlsx)';
    }

    public function exportAppointments(): string
    {
        $format = strtolower($_GET['format'] ?? '');
        $rows = $this->fetchAppointments();

        if ($format === 'xlsx') {
            $this->outputXlsx('appointments', ['ID','Datum','Slot','Majstor','Klijent','Vozilo','Status'], $rows);
            return '';
        }
        if ($format === 'pdf') {
            $this->outputPdf('Appointments', ['ID','Datum','Slot','Majstor','Klijent','Vozilo','Status'], $rows);
            return '';
        }

        http_response_code(400);
        return 'Bad Request: missing format (pdf|xlsx)';
    }

    // ===== Helpers =====

    private function fetchInquiries(): array
    {
        $sql = "SELECT id, date_requested, customer_name, contact_email, contact_phone, vehicle_desc, notes, status
                FROM inquiries ORDER BY id DESC";
        $stmt = $this->pdo->query($sql);
        return $stmt ? $stmt->fetchAll(PDO::FETCH_ASSOC) : [];
    }

    private function fetchAppointments(): array
    {
        $sql = "SELECT a.id, a.date, a.slot, m.alias AS mechanic, c.name AS customer,
                       v.plate_number AS vehicle, a.status
                  FROM appointments a
             LEFT JOIN mechanics m ON m.id = a.mechanic_id
             LEFT JOIN customers c ON c.id = a.customer_id
             LEFT JOIN vehicles  v ON v.id = a.vehicle_id
              ORDER BY a.id DESC";
        $stmt = $this->pdo->query($sql);
        return $stmt ? $stmt->fetchAll(PDO::FETCH_ASSOC) : [];
    }

    private function outputXlsx(string $baseName, array $headers, array $rows): void
    {
        $spreadsheet = new Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();

        // Header
        foreach ($headers as $i => $h) {
            $sheet->setCellValueByColumnAndRow($i+1, 1, $h);
        }
        // Rows
        $r = 2;
        foreach ($rows as $row) {
            $c = 1;
            foreach ($row as $val) {
                $sheet->setCellValueByColumnAndRow($c++, $r, (string)$val);
            }
            $r++;
        }

        // Output
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment; filename="'.$baseName.'.xlsx"');
        header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');

        $writer = new Xlsx($spreadsheet);
        // na Windowsu zna da pomogne isključivanje disk cache-a:
        // $writer->setPreCalculateFormulas(false);
        $writer->save('php://output');
        exit;
    }

    private function outputPdf(string $title, array $headers, array $rows): void
    {
        // mPDF zna da traži temp dir (posebno na Windowsu)
        $mpdf = new Mpdf([
            'tempDir' => $this->config['paths']['tmp'] ?? sys_get_temp_dir(),
        ]);

        $html = '<h2>'.htmlspecialchars($title).'</h2><table border="1" cellspacing="0" cellpadding="6"><tr>';
        foreach ($headers as $h) {
            $html .= '<th>'.htmlspecialchars($h).'</th>';
        }
        $html .= '</tr>';

        foreach ($rows as $row) {
            $html .= '<tr>';
            foreach ($row as $val) {
                $html .= '<td>'.htmlspecialchars((string)$val).'</td>';
            }
            $html .= '</tr>';
        }
        $html .= '</table>';

        $mpdf->WriteHTML($html);
        $mpdf->Output($title . '.pdf', 'D'); // force download
        exit;
    }
}
