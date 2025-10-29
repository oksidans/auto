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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-29 20:43:47
