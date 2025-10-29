-- MySQL dump 10.13  Distrib 8.0.44, for Linux (x86_64)
--
-- Host: localhost    Database: autoservis
-- ------------------------------------------------------
-- Server version	8.0.44-1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity_log`
--

DROP TABLE IF EXISTS `activity_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `action` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_type` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entity_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `details` json DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_log_user` (`user_id`),
  KEY `idx_log_action` (`action`),
  KEY `idx_log_entity` (`entity_type`,`entity_id`),
  CONSTRAINT `fk_log_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log`
--

LOCK TABLES `activity_log` WRITE;
/*!40000 ALTER TABLE `activity_log` DISABLE KEYS */;
INSERT INTO `activity_log` VALUES (1,5,'auth.logout','user',5,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-08 23:29:36'),(2,6,'auth.register','user',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-13 21:43:31'),(3,6,'auth.logout','user',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-13 21:44:00'),(4,6,'auth.login','user',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-13 21:44:05'),(5,6,'auth.logout','user',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-13 21:47:22'),(6,1,'auth.login','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-13 21:54:59'),(7,1,'auth.logout','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-13 22:00:53'),(8,1,'auth.login','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-13 22:00:56'),(9,1,'auth.login','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-13 22:01:15'),(10,1,'inquiry.convert','inquiry',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"date\": \"2025-10-13\", \"slot\": 1, \"mechanic_id\": 2, \"appointment_id\": 1}','2025-10-13 22:04:36'),(11,1,'auth.login','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 23:13:57'),(12,1,'auth.logout','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 23:14:07'),(13,6,'auth.login','user',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 23:14:13'),(14,6,'auth.logout','user',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 23:16:20'),(15,6,'auth.login','user',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 23:21:09'),(16,6,'auth.logout','user',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 23:21:35'),(17,7,'auth.login','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 23:40:00'),(18,7,'report.export','inquiries',NULL,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"format\": \"xlsx\"}','2025-10-14 23:41:25'),(19,7,'auth.logout','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 23:43:20'),(20,6,'auth.login','user',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 23:44:50'),(21,6,'inquiry.create','inquiry',2,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"preferred_mechanic_id\": 3}','2025-10-14 23:45:29'),(22,6,'auth.logout','user',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 23:45:35'),(23,1,'auth.login','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 23:45:42'),(24,1,'inquiry.create','inquiry',3,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"preferred_mechanic_id\": 3}','2025-10-14 23:46:14'),(25,1,'inquiry.convert','inquiry',3,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"date\": \"2025-10-14\", \"slot\": 1, \"mechanic_id\": 3, \"appointment_id\": 2}','2025-10-14 23:46:41'),(26,1,'auth.logout','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 23:46:46'),(27,7,'auth.login','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 23:47:03'),(28,7,'report.export','inquiries',NULL,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"format\": \"xlsx\"}','2025-10-14 23:47:13'),(29,7,'auth.logout','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-14 23:47:59'),(30,7,'auth.login','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2025-10-15 20:57:03'),(31,7,'auth.logout','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2025-10-15 20:57:34'),(32,6,'auth.login','user',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:02:59'),(33,6,'inquiry.create','inquiry',4,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"preferred_mechanic_id\": 2}','2025-10-15 21:03:40'),(34,6,'auth.logout','user',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:03:55'),(35,1,'auth.login','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:04:16'),(36,1,'inquiry.convert','inquiry',2,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"date\": \"2025-10-15\", \"slot\": 1, \"mechanic_id\": 3, \"appointment_id\": 3}','2025-10-15 21:05:06'),(37,1,'inquiry.convert','inquiry',4,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"date\": \"2025-10-15\", \"slot\": 1, \"mechanic_id\": 2, \"appointment_id\": 4}','2025-10-15 21:05:09'),(38,1,'auth.logout','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:05:14'),(39,8,'auth.login','user',8,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:06:33'),(40,8,'inquiry.create','inquiry',5,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"preferred_mechanic_id\": 3}','2025-10-15 21:07:17'),(41,8,'auth.logout','user',8,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:07:22'),(42,1,'auth.login','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:07:30'),(43,1,'auth.logout','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:11:37'),(44,1,'auth.login','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:18:53'),(45,1,'auth.logout','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:19:09'),(46,7,'auth.login','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:19:17'),(47,7,'auth.logout','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:24:56'),(48,8,'auth.login','user',8,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:25:26'),(49,8,'inquiry.create','inquiry',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"preferred_mechanic_id\": 2}','2025-10-15 21:26:28'),(50,8,'auth.logout','user',8,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:26:34'),(51,1,'auth.login','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:26:50'),(52,1,'inquiry.convert','inquiry',5,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"date\": \"2025-10-15\", \"slot\": 2, \"mechanic_id\": 3, \"appointment_id\": 5}','2025-10-15 21:27:17'),(53,1,'inquiry.convert','inquiry',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"date\": \"2025-10-15\", \"slot\": 2, \"mechanic_id\": 2, \"appointment_id\": 6}','2025-10-15 21:27:22'),(54,1,'auth.logout','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:27:33'),(55,7,'auth.login','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:27:42'),(56,7,'report.export','appointments',NULL,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"format\": \"xlsx\"}','2025-10-15 21:27:53'),(57,7,'auth.logout','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-15 21:28:13'),(58,7,'auth.login','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-28 21:01:44'),(59,7,'report.export','inquiries',NULL,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"format\": \"xlsx\"}','2025-10-28 21:02:41'),(60,7,'auth.logout','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-28 21:09:28'),(61,1,'auth.login','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-28 21:10:08'),(62,1,'auth.logout','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-28 21:10:17'),(63,6,'auth.login','user',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-28 21:12:52'),(64,6,'inquiry.create','inquiry',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"preferred_mechanic_id\": 2}','2025-10-28 21:13:37'),(65,6,'auth.logout','user',6,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-28 21:13:44'),(66,1,'auth.login','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-28 21:13:54'),(67,1,'inquiry.convert','inquiry',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"date\": \"2025-10-28\", \"slot\": 1, \"mechanic_id\": 2, \"appointment_id\": 7}','2025-10-28 21:14:09'),(68,1,'auth.logout','user',1,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-28 21:14:16'),(69,7,'auth.login','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-28 21:14:31'),(70,7,'report.export','inquiries',NULL,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"format\": \"pdf\"}','2025-10-28 21:14:39'),(71,7,'report.export','inquiries',NULL,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"format\": \"xlsx\"}','2025-10-28 21:14:49'),(72,7,'report.export','appointments',NULL,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"format\": \"pdf\"}','2025-10-28 21:15:00'),(73,7,'report.export','appointments',NULL,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','{\"format\": \"xlsx\"}','2025-10-28 21:15:17'),(74,7,'auth.logout','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-28 21:15:26'),(75,7,'auth.login','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-28 23:21:18'),(76,7,'auth.logout','user',7,'::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',NULL,'2025-10-28 23:24:33');
/*!40000 ALTER TABLE `activity_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `slot` tinyint unsigned NOT NULL,
  `mechanic_id` bigint unsigned NOT NULL,
  `customer_id` bigint unsigned NOT NULL,
  `vehicle_id` bigint unsigned DEFAULT NULL,
  `status` enum('pending','approved','in_service','ready','closed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `approved_at` datetime DEFAULT NULL,
  `in_service_at` datetime DEFAULT NULL,
  `ready_at` datetime DEFAULT NULL,
  `closed_at` datetime DEFAULT NULL,
  `closed_by_user_id` bigint unsigned DEFAULT NULL,
  `handover_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_mech_day_slot` (`date`,`mechanic_id`,`slot`),
  KEY `idx_appt_mech_day` (`mechanic_id`,`date`),
  KEY `idx_appt_customer` (`customer_id`),
  KEY `idx_appt_vehicle` (`vehicle_id`),
  KEY `idx_appt_status` (`status`),
  KEY `fk_appt_closed_by` (`closed_by_user_id`),
  CONSTRAINT `fk_appt_closed_by` FOREIGN KEY (`closed_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_appt_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_appt_mechanic` FOREIGN KEY (`mechanic_id`) REFERENCES `mechanics` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_appt_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_slot` CHECK ((`slot` in (1,2)))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (1,'2025-10-13',1,2,1,NULL,'approved','2025-10-13 22:04:36',NULL,NULL,NULL,NULL,NULL,NULL),(2,'2025-10-14',1,3,3,NULL,'approved','2025-10-14 23:46:41',NULL,NULL,NULL,NULL,NULL,NULL),(3,'2025-10-15',1,3,3,NULL,'approved','2025-10-15 21:05:06',NULL,NULL,NULL,NULL,NULL,NULL),(4,'2025-10-15',1,2,3,NULL,'approved','2025-10-15 21:05:09',NULL,NULL,NULL,NULL,NULL,NULL),(5,'2025-10-15',2,3,3,NULL,'approved','2025-10-15 21:27:17',NULL,NULL,NULL,NULL,NULL,NULL),(6,'2025-10-15',2,2,1,NULL,'approved','2025-10-15 21:27:22',NULL,NULL,NULL,NULL,NULL,NULL),(7,'2025-10-28',1,2,4,NULL,'approved','2025-10-28 21:14:09',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `name` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_customers_user` (`user_id`),
  KEY `idx_customers_email` (`email`),
  KEY `idx_customers_phone` (`phone`),
  CONSTRAINT `fk_customers_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,5,'Miroljub Zivkovic','zmiroljub.zivkovic@gmail.com',NULL,'2025-10-08 22:25:34'),(2,6,'Dragana Zivkovic','drzgana@gmail.com',NULL,'2025-10-13 21:43:31'),(3,NULL,'Dragana Zivkovic','dzivkovic@gmail.com','0643382528','2025-10-14 23:46:41'),(4,NULL,'dR dragana Zivkovicc Joj','dzivkovic@joj.com','0643352528','2025-10-28 21:14:09');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Table structure for table `mechanics`
--

DROP TABLE IF EXISTS `mechanics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mechanics` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `alias` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_mech_user` (`user_id`),
  CONSTRAINT `fk_mech_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mechanics`
--

LOCK TABLES `mechanics` WRITE;
/*!40000 ALTER TABLE `mechanics` DISABLE KEYS */;
INSERT INTO `mechanics` VALUES (1,2,'Milan',1,'2025-10-07 22:46:03'),(2,3,'Jovan',1,'2025-10-07 22:46:03'),(3,4,'Ana',1,'2025-10-07 22:46:03');
/*!40000 ALTER TABLE `mechanics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','manager','mechanic','user') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `full_name` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'manager@example.com','$2y$12$5j53ZVBr1.DM42RAyzgz.uB4UNY4fWjo1/VF.rRCf.HuG9pltgmh6','manager','Menadžer',1,'2025-10-07 22:46:03','2025-10-13 21:53:27'),(2,'milan@example.com','$2y$10$dummydummydummydummydummyhash','mechanic','Milan Majstor',1,'2025-10-07 22:46:03','2025-10-07 22:46:03'),(3,'jovan@example.com','$2y$10$dummydummydummydummydummyhash','mechanic','Jovan Majstor',1,'2025-10-07 22:46:03','2025-10-07 22:46:03'),(4,'ana@example.com','$2y$10$dummydummydummydummydummyhash','mechanic','Ana Majstor',1,'2025-10-07 22:46:03','2025-10-07 22:46:03'),(5,'zmiroljub.zivkovic@gmail.com','$2y$12$ozopS0I2gfV6yIYsMMgeTeefJZUixgyZ1s6J7OPmoRoWjS/m4fOTS','user','Miroljub Zivkovic',1,'2025-10-08 22:25:34','2025-10-08 22:25:34'),(6,'drzgana@gmail.com','$2y$12$2uYzMsFnibZzuUQ.Rjwp9upJUqYH.Mi5lJ/4JOsiocVcYZ61BSwX.','user','Dragana Zivkovic',1,'2025-10-13 21:43:31','2025-10-13 21:43:31'),(7,'admin@example.com','$2y$12$ZfK9Rkm/rU7yazHqFufVvOTe1XF2FerPU46j0UJiTxrI/3jXH9gFq','admin','Administrator',1,'2025-10-14 23:30:41','2025-10-14 23:39:44'),(8,'zmiroljub@msn.com','$2y$12$6kBNE/RNA88HySH0bMn9OeBpwN1iPU5Xd1TtukZNUrmZNhaGDOKUu','user','miki',1,'2025-10-15 21:06:28','2025-10-15 21:06:28');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_daily_capacity`
--

DROP TABLE IF EXISTS `v_daily_capacity`;
/*!50001 DROP VIEW IF EXISTS `v_daily_capacity`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_daily_capacity` AS SELECT 
 1 AS `date`,
 1 AS `mechanic_id`,
 1 AS `alias`,
 1 AS `taken_slots`,
 1 AS `free_slots`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` bigint unsigned NOT NULL,
  `plate_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `make` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `year` smallint unsigned DEFAULT NULL,
  `vin` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_vehicle_plate` (`plate_number`),
  KEY `idx_vehicles_customer` (`customer_id`),
  CONSTRAINT `fk_vehicles_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `v_daily_capacity`
--

/*!50001 DROP VIEW IF EXISTS `v_daily_capacity`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_daily_capacity` AS select `a`.`date` AS `date`,`m`.`id` AS `mechanic_id`,`m`.`alias` AS `alias`,count(`a`.`id`) AS `taken_slots`,(2 - count(`a`.`id`)) AS `free_slots` from (`mechanics` `m` left join `appointments` `a` on((`a`.`mechanic_id` = `m`.`id`))) group by `a`.`date`,`m`.`id`,`m`.`alias` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-29 20:41:44
