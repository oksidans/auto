-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: localhost    Database: autoservis
-- ------------------------------------------------------
-- Server version	8.0.44-1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `inquiries`
--

DROP TABLE IF EXISTS `inquiries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiries` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `date_requested` date NOT NULL,
  `customer_name` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_email` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_phone` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vehicle_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `preferred_mechanic_id` bigint unsigned DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` enum('new','contacted','converted','closed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'new',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `converted_to_appointment_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_inq_date` (`date_requested`),
  KEY `idx_inq_status` (`status`),
  KEY `fk_inq_to_appt` (`converted_to_appointment_id`),
  KEY `idx_inq_pref_mech` (`preferred_mechanic_id`),
  CONSTRAINT `fk_inq_pref_mech` FOREIGN KEY (`preferred_mechanic_id`) REFERENCES `mechanics` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_inq_to_appt` FOREIGN KEY (`converted_to_appointment_id`) REFERENCES `appointments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inquiries`
--

LOCK TABLES `inquiries` WRITE;
/*!40000 ALTER TABLE `inquiries` DISABLE KEYS */;
INSERT INTO `inquiries` VALUES (1,'2025-10-08','Miroljub Zivkovic','zmiroljub.zivkovic@gmail.com','0643382528','opel astra h',NULL,NULL,'converted','2025-10-08 23:04:32',1),(2,'2025-10-14','Dragana Zivkovic','dzivkovic@gmail.com','0643382528','Yugo 55',3,'Molim vas potvrdu','converted','2025-10-14 23:45:29',3),(3,'2025-10-14','Dragana Zivkovic','dzivkovic@gmail.com','0643382528','YUgo 55',3,NULL,'converted','2025-10-14 23:46:14',2),(4,'2025-10-15','DRagana Zivkovic','fzivkovic@gmail.com','0643382528','Yugo 45',2,'Javite mi','converted','2025-10-15 21:03:40',4),(5,'2025-10-15','Miroljub ZIvkovic','mzivkovic@msn.com','0643382528','Alfa Romeo',3,NULL,'converted','2025-10-15 21:07:17',5),(6,'2025-10-15','Miroljub Zivkovic','zmiroljub.zivkovic@gmail.com','0643382528','Mercedes 2200',2,'JAvite mi da li je moguce da bude za danas','converted','2025-10-15 21:26:28',6),(7,'2025-10-28','dR dragana Zivkovicc Joj','dzivkovic@joj.com','0643352528','Yugo 45',2,'Da bude gotovo do sutra','converted','2025-10-28 21:13:37',7);
/*!40000 ALTER TABLE `inquiries` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-29 20:43:47
