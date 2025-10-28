-- 1) BAZA
DROP DATABASE IF EXISTS autoservis;
CREATE DATABASE autoservis
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE autoservis;

-- 2) USERS (sistemski nalozi)
CREATE TABLE users (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email           VARCHAR(190) NOT NULL UNIQUE,
  password_hash   VARCHAR(255) NOT NULL,
  role            ENUM('admin','manager','mechanic','user') NOT NULL DEFAULT 'user',
  full_name       VARCHAR(190) NOT NULL,
  is_active       TINYINT(1) NOT NULL DEFAULT 1,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3) MECHANICS (majstori; 1:1 sa users, role=mechanic - aplikativno proveriti)
CREATE TABLE mechanics (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id     BIGINT UNSIGNED NOT NULL,
  alias       VARCHAR(100) NOT NULL,             -- npr. "Milan"
  is_active   TINYINT(1) NOT NULL DEFAULT 1,
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_mech_user (user_id),
  CONSTRAINT fk_mech_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 4) CUSTOMERS (klijenti; mogu imati i sistemski nalog - nije obavezno)
CREATE TABLE customers (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id     BIGINT UNSIGNED NULL,              -- nullable: gost može postati registrovan kasnije
  name        VARCHAR(190) NOT NULL,
  email       VARCHAR(190) NULL,
  phone       VARCHAR(60)  NULL,
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_customers_user (user_id),
  KEY idx_customers_email (email),
  KEY idx_customers_phone (phone),
  CONSTRAINT fk_customers_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- 5) VEHICLES (vozila)
CREATE TABLE vehicles (
  id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  customer_id   BIGINT UNSIGNED NOT NULL,
  plate_number  VARCHAR(20)  NOT NULL,           -- registracija
  make          VARCHAR(60)  NOT NULL,           -- marka
  model         VARCHAR(80)  NOT NULL,
  year          SMALLINT UNSIGNED NULL,
  vin           VARCHAR(30)  NULL,
  created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_vehicle_plate (plate_number),
  KEY idx_vehicles_customer (customer_id),
  CONSTRAINT fk_vehicles_customer
    FOREIGN KEY (customer_id) REFERENCES customers(id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 6) APPOINTMENTS (termini / servisni slučajevi)
-- Ograničenje: max 2 po majstoru dnevno -> slot TINYINT (1 ili 2) + UNIQUE(date, mechanic_id, slot)
CREATE TABLE appointments (
  id                 BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  date               DATE NOT NULL,
  slot               TINYINT UNSIGNED NOT NULL,   -- 1 ili 2
  mechanic_id        BIGINT UNSIGNED NOT NULL,
  customer_id        BIGINT UNSIGNED NOT NULL,
  vehicle_id         BIGINT UNSIGNED NULL,        -- može biti NULL dok je samo upit/rezervacija
  status             ENUM('pending','approved','in_service','ready','closed')
                       NOT NULL DEFAULT 'pending',
  created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  approved_at        DATETIME NULL,
  in_service_at      DATETIME NULL,
  ready_at           DATETIME NULL,
  closed_at          DATETIME NULL,
  closed_by_user_id  BIGINT UNSIGNED NULL,        -- menadžer/admin koji je zatvorio
  handover_notes     TEXT NULL,

  -- Indeksi i ograničenja kapaciteta
  UNIQUE KEY uq_mech_day_slot (date, mechanic_id, slot),
  KEY idx_appt_mech_day (mechanic_id, date),
  KEY idx_appt_customer (customer_id),
  KEY idx_appt_vehicle (vehicle_id),
  KEY idx_appt_status (status),
  
  CONSTRAINT fk_appt_mechanic
    FOREIGN KEY (mechanic_id) REFERENCES mechanics(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_appt_customer
    FOREIGN KEY (customer_id) REFERENCES customers(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_appt_vehicle
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_appt_closed_by
    FOREIGN KEY (closed_by_user_id) REFERENCES users(id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  -- Validacija slot-a (MySQL 8: CHECK je dekorativan u 8.0.30-, ali ga ostavljamo za jasnoću)
  CONSTRAINT chk_slot CHECK (slot IN (1,2))
) ENGINE=InnoDB;

-- 7) INQUIRIES (upiti gostiju za termin)
CREATE TABLE inquiries (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  date_requested  DATE NOT NULL,                 -- datum za koji je gost pitao (npr. današnji)
  customer_name   VARCHAR(190) NOT NULL,
  contact_email   VARCHAR(190) NULL,
  contact_phone   VARCHAR(60)  NULL,
  vehicle_desc    VARCHAR(255) NULL,             -- kratko: marka/model/reg broj…
  notes           TEXT NULL,
  status          ENUM('new','contacted','converted','closed') NOT NULL DEFAULT 'new',
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  converted_to_appointment_id BIGINT UNSIGNED NULL,
  KEY idx_inq_date (date_requested),
  KEY idx_inq_status (status),
  CONSTRAINT fk_inq_to_appt
    FOREIGN KEY (converted_to_appointment_id) REFERENCES appointments(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- 8) ACTIVITY LOG (loga korisničkih akcija)
CREATE TABLE activity_log (
  id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id      BIGINT UNSIGNED NULL,          -- može biti NULL za gosta
  action       VARCHAR(100) NOT NULL,         -- npr. "appointment.close", "customers.list"
  entity_type  VARCHAR(60)  NULL,             -- "appointment","customer","inquiry"...
  entity_id    BIGINT UNSIGNED NULL,
  ip_address   VARCHAR(45)  NULL,             -- IPv4/IPv6
  user_agent   VARCHAR(255) NULL,
  details      JSON NULL,                      -- dodatni parametri
  created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_log_user (user_id),
  KEY idx_log_action (action),
  KEY idx_log_entity (entity_type, entity_id),
  CONSTRAINT fk_log_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- 9) (Opcionalno) VIEW za dnevnu dostupnost po majstorima
-- Prikazuje koliko je slotova zauzeto po majstoru za dati dan
CREATE OR REPLACE VIEW v_daily_capacity AS
SELECT
  a.date,
  m.id   AS mechanic_id,
  m.alias,
  COUNT(a.id) AS taken_slots,
  (2 - COUNT(a.id)) AS free_slots
FROM mechanics m
LEFT JOIN appointments a
  ON a.mechanic_id = m.id
GROUP BY a.date, m.id, m.alias;

-- 10) Seed (primer: 1 manager + 3 majstora)
-- Lozinke su primeri (hash treba generisati u aplikaciji).
INSERT INTO users (email, password_hash, role, full_name) VALUES
('manager@example.com',   '$2y$10$dummydummydummydummydummyhash', 'manager',  'Menadžer'),
('milan@example.com',     '$2y$10$dummydummydummydummydummyhash', 'mechanic', 'Milan Majstor'),
('jovan@example.com',     '$2y$10$dummydummydummydummydummyhash', 'mechanic', 'Jovan Majstor'),
('ana@example.com',       '$2y$10$dummydummydummydummydummyhash', 'mechanic', 'Ana Majstor');

INSERT INTO mechanics (user_id, alias) VALUES
((SELECT id FROM users WHERE email='milan@example.com'), 'Milan'),
((SELECT id FROM users WHERE email='jovan@example.com'), 'Jovan'),
((SELECT id FROM users WHERE email='ana@example.com'),   'Ana');
