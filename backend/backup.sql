-- MySQL dump 10.13  Distrib 8.3.0, for Linux (x86_64)
--
-- Host: localhost    Database: A202DB
-- ------------------------------------------------------
-- Server version	8.3.0

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
-- Table structure for table `account_emailaddress`
--

DROP TABLE IF EXISTS `account_emailaddress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_emailaddress` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `verified` tinyint(1) NOT NULL,
  `primary` tinyint(1) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_emailaddress_user_id_email_987c8728_uniq` (`user_id`,`email`),
  KEY `account_emailaddress_upper` ((upper(`email`))),
  CONSTRAINT `account_emailaddress_user_id_2c513194_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_emailaddress`
--

LOCK TABLES `account_emailaddress` WRITE;
/*!40000 ALTER TABLE `account_emailaddress` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_emailaddress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_emailconfirmation`
--

DROP TABLE IF EXISTS `account_emailconfirmation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_emailconfirmation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created` datetime(6) NOT NULL,
  `sent` datetime(6) DEFAULT NULL,
  `key` varchar(64) NOT NULL,
  `email_address_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`),
  KEY `account_emailconfirm_email_address_id_5b7f8c58_fk_account_e` (`email_address_id`),
  CONSTRAINT `account_emailconfirm_email_address_id_5b7f8c58_fk_account_e` FOREIGN KEY (`email_address_id`) REFERENCES `account_emailaddress` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_emailconfirmation`
--

LOCK TABLES `account_emailconfirmation` WRITE;
/*!40000 ALTER TABLE `account_emailconfirmation` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_emailconfirmation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_user`
--

DROP TABLE IF EXISTS `accounts_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `username` varchar(30) NOT NULL,
  `nickname` varchar(255) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `handicap` smallint DEFAULT NULL,
  `is_resigned` tinyint(1) NOT NULL,
  `resigned_at` datetime(6) DEFAULT NULL,
  `connected_device` int DEFAULT NULL,
  `device_permission` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_user`
--

LOCK TABLES `accounts_user` WRITE;
/*!40000 ALTER TABLE `accounts_user` DISABLE KEYS */;
INSERT INTO `accounts_user` VALUES (1,'pbkdf2_sha256$600000$atrVrxBqrW1BUbfm4vbxMF$TH6G0M03fripvUl52cS+n6o10VEv6wZcQqMg5tv16gM=',NULL,1,'','',1,1,'2024-02-13 14:30:14.208819','admin',NULL,'hojoon1105@naver.com',NULL,0,NULL,NULL,0),(2,'pbkdf2_sha256$600000$wIvs7yB4MF1E83XJKz3gvc$4DQszNFCu7Kv4dHJ2qC50Z3Ql+fvGFXWWWG5kB2QRF8=','2024-02-15 06:52:56.358604',0,'','',0,1,'2024-02-13 14:34:33.828099','moeun1','모은햄','testemail12@gmail.com',7,0,NULL,111111,0),(3,'pbkdf2_sha256$600000$FftpRsBcm9vobcNiLnsZyD$1T2YZqLNiNQ4tReG/Wvi6xZpvCEGvvuf+5ISEqhcGDU=','2024-02-14 02:32:45.545614',0,'','',0,1,'2024-02-14 01:22:21.549406','moeun3','momo','moeun@mn.com',10,0,NULL,NULL,0),(4,'pbkdf2_sha256$600000$Bg1BqLFvESdilZ98U3q5Uz$ko6GiHffcSGRb30xtN0TKi4KmxsCsRtRfUMB/cXQ7hE=','2024-02-15 04:54:37.607774',0,'','',0,1,'2024-02-15 01:20:35.822198','dangdangyi','댕댕이','a@a.com',10,0,NULL,NULL,0),(5,'pbkdf2_sha256$600000$URpFINm56vteokYgkNCegF$ZXVjfPue2nHa+x/lH8uDx+3ouNgxzMorR/ylard88CQ=','2024-02-15 05:40:14.560514',0,'','',0,1,'2024-02-15 05:40:14.124178','user1','컨설턴트님','user1@gmail.com',13,0,NULL,NULL,0),(6,'pbkdf2_sha256$600000$unsfzNcFT0XrlwI1elRTtJ$vr5iZuwKpESivKkp5VNz5hfLymmA2IKkpwkilLb6I0A=','2024-02-15 05:41:16.163958',0,'','',0,1,'2024-02-15 05:41:15.727495','user2','코치님','user2@gmail.com',11,0,NULL,NULL,0),(7,'pbkdf2_sha256$600000$S36y8Db4lkjlDVSrpyc850$H6jRDU4zd0OFXoFPr+yUGQXuvHEwobr32Qd7nzBI9js=','2024-02-15 05:59:23.012711',0,'','',0,1,'2024-02-15 05:58:38.702065','dusdn0224','이연우','ssafy@ssafy.com',NULL,0,NULL,NULL,0);
/*!40000 ALTER TABLE `accounts_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_user_groups`
--

DROP TABLE IF EXISTS `accounts_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounts_user_groups_user_id_group_id_59c0b32f_uniq` (`user_id`,`group_id`),
  KEY `accounts_user_groups_group_id_bd11a704_fk_auth_group_id` (`group_id`),
  CONSTRAINT `accounts_user_groups_group_id_bd11a704_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `accounts_user_groups_user_id_52b62117_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_user_groups`
--

LOCK TABLES `accounts_user_groups` WRITE;
/*!40000 ALTER TABLE `accounts_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_user_user_permissions`
--

DROP TABLE IF EXISTS `accounts_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounts_user_user_permi_user_id_permission_id_2ab516c2_uniq` (`user_id`,`permission_id`),
  KEY `accounts_user_user_p_permission_id_113bb443_fk_auth_perm` (`permission_id`),
  CONSTRAINT `accounts_user_user_p_permission_id_113bb443_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `accounts_user_user_p_user_id_e4f0a161_fk_accounts_` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_user_user_permissions`
--

LOCK TABLES `accounts_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `accounts_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add user',6,'add_user'),(22,'Can change user',6,'change_user'),(23,'Can delete user',6,'delete_user'),(24,'Can view user',6,'view_user'),(25,'Can add board',7,'add_board'),(26,'Can change board',7,'change_board'),(27,'Can delete board',7,'delete_board'),(28,'Can view board',7,'view_board'),(29,'Can add comment',8,'add_comment'),(30,'Can change comment',8,'change_comment'),(31,'Can delete comment',8,'delete_comment'),(32,'Can view comment',8,'view_comment'),(33,'Can add question',9,'add_question'),(34,'Can change question',9,'change_question'),(35,'Can delete question',9,'delete_question'),(36,'Can view question',9,'view_question'),(37,'Can add answer',10,'add_answer'),(38,'Can change answer',10,'change_answer'),(39,'Can delete answer',10,'delete_answer'),(40,'Can view answer',10,'view_answer'),(41,'Can add location',11,'add_location'),(42,'Can change location',11,'change_location'),(43,'Can delete location',11,'delete_location'),(44,'Can view location',11,'view_location'),(45,'Can add route',12,'add_route'),(46,'Can change route',12,'change_route'),(47,'Can delete route',12,'delete_route'),(48,'Can view route',12,'view_route'),(49,'Can add device',13,'add_device'),(50,'Can change device',13,'change_device'),(51,'Can delete device',13,'delete_device'),(52,'Can view device',13,'view_device'),(53,'Can add Token',14,'add_token'),(54,'Can change Token',14,'change_token'),(55,'Can delete Token',14,'delete_token'),(56,'Can view Token',14,'view_token'),(57,'Can add token',15,'add_tokenproxy'),(58,'Can change token',15,'change_tokenproxy'),(59,'Can delete token',15,'delete_tokenproxy'),(60,'Can view token',15,'view_tokenproxy'),(61,'Can add social application',16,'add_socialapp'),(62,'Can change social application',16,'change_socialapp'),(63,'Can delete social application',16,'delete_socialapp'),(64,'Can view social application',16,'view_socialapp'),(65,'Can add social account',17,'add_socialaccount'),(66,'Can change social account',17,'change_socialaccount'),(67,'Can delete social account',17,'delete_socialaccount'),(68,'Can view social account',17,'view_socialaccount'),(69,'Can add social application token',18,'add_socialtoken'),(70,'Can change social application token',18,'change_socialtoken'),(71,'Can delete social application token',18,'delete_socialtoken'),(72,'Can view social application token',18,'view_socialtoken'),(73,'Can add email address',19,'add_emailaddress'),(74,'Can change email address',19,'change_emailaddress'),(75,'Can delete email address',19,'delete_emailaddress'),(76,'Can view email address',19,'view_emailaddress'),(77,'Can add email confirmation',20,'add_emailconfirmation'),(78,'Can change email confirmation',20,'change_emailconfirmation'),(79,'Can delete email confirmation',20,'delete_emailconfirmation'),(80,'Can view email confirmation',20,'view_emailconfirmation');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authtoken_token`
--

DROP TABLE IF EXISTS `authtoken_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authtoken_token` (
  `key` varchar(40) NOT NULL,
  `created` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `authtoken_token_user_id_35299eff_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authtoken_token`
--

LOCK TABLES `authtoken_token` WRITE;
/*!40000 ALTER TABLE `authtoken_token` DISABLE KEYS */;
INSERT INTO `authtoken_token` VALUES ('9a924fc843a0fc8502bf2966504d02cbb27839fe','2024-02-15 05:58:48.375760',7),('a65ab027693d382cd8341a907039db1df78609bc','2024-02-15 06:52:55.864446',2);
/*!40000 ALTER TABLE `authtoken_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `balls_location`
--

DROP TABLE IF EXISTS `balls_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `balls_location` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `loca_file` json NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_quiz` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `balls_location`
--

LOCK TABLES `balls_location` WRITE;
/*!40000 ALTER TABLE `balls_location` DISABLE KEYS */;
INSERT INTO `balls_location` VALUES (1,'{\"positions\": {\"red\": [[90, 30]], \"white\": [[30, 15]], \"yellow\": [[30, 45]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1),(2,'{\"positions\": {\"red\": [[98, 9]], \"white\": [[15, 10]], \"yellow\": [[55, 14]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1),(3,'{\"positions\": {\"red\": [[95, 13]], \"white\": [[10, 10]], \"yellow\": [[50, 10]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1),(4,'{\"positions\": {\"red\": [[33, 15]], \"white\": [[105, 10]], \"yellow\": [[33, 45]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1),(5,'{\"positions\": {\"red\": [[90, 15]], \"white\": [[100, 48]], \"yellow\": [[60, 46]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1),(6,'{\"positions\": {\"red\": [[100, 11]], \"white\": [[102, 50]], \"yellow\": [[30, 11]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1),(7,'{\"positions\": {\"red\": [[40, 9]], \"white\": [[15, 45]], \"yellow\": [[95, 46]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1),(8,'{\"positions\": {\"red\": [[90, 15]], \"white\": [[41, 13]], \"yellow\": [[93, 43]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1),(9,'{\"positions\": {\"red\": [[33, 11]], \"white\": [[10, 14]], \"yellow\": [[85, 12]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1),(10,'{\"positions\": {\"red\": [[33, 57]], \"white\": [[40, 6]], \"yellow\": [[110, 52]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1),(11,'{\"positions\": {\"red\": [[15, 14]], \"white\": [[20, 18]], \"yellow\": [[45, 30]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1),(12,'{\"positions\": {\"red\": [[45, 19]], \"white\": [[35, 6]], \"yellow\": [[100, 10]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1);
/*!40000 ALTER TABLE `balls_location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `balls_route`
--

DROP TABLE IF EXISTS `balls_route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `balls_route` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `route_file` json NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `device_seq_id` bigint NOT NULL,
  `loca_seq_id` bigint NOT NULL,
  `user_seq_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `balls_route_device_seq_id_d1ce3e07_fk_devices_device_id` (`device_seq_id`),
  KEY `balls_route_loca_seq_id_b4e13d0f_fk_balls_location_id` (`loca_seq_id`),
  KEY `balls_route_user_seq_id_b4ab5d93_fk_accounts_user_id` (`user_seq_id`),
  CONSTRAINT `balls_route_device_seq_id_d1ce3e07_fk_devices_device_id` FOREIGN KEY (`device_seq_id`) REFERENCES `devices_device` (`id`),
  CONSTRAINT `balls_route_loca_seq_id_b4e13d0f_fk_balls_location_id` FOREIGN KEY (`loca_seq_id`) REFERENCES `balls_location` (`id`),
  CONSTRAINT `balls_route_user_seq_id_b4ab5d93_fk_accounts_user_id` FOREIGN KEY (`user_seq_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `balls_route`
--

LOCK TABLES `balls_route` WRITE;
/*!40000 ALTER TABLE `balls_route` DISABLE KEYS */;
INSERT INTO `balls_route` VALUES (1,'{\"positions\": {\"red\": [[90, 30], [90, 30], [90, 30], [90, 30], [90, 30], [90, 30]], \"white\": [[30, 15], [30, 15], [30, 15], [30, 15], [30, 15], [30, 15]], \"yellow\": [[30, 45], [88, 28], [100, 0], [120, 14], [88, 60], [30, 15]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 6, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1,1,1),(2,'{\"positions\": {\"red\": [[98, 9], [98, 9], [98, 9], [98, 9], [98, 9], [98, 9]], \"white\": [[15, 10], [15, 10], [15, 10], [15, 10], [15, 10], [15, 10]], \"yellow\": [[55, 14], [97, 11], [120, 31], [80, 60], [0, 15], [15, 10]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 6, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1,2,1),(3,'{\"positions\": {\"red\": [[95, 13], [95, 13], [95, 13], [95, 13], [95, 13], [95, 13]], \"white\": [[10, 10], [10, 10], [10, 10], [10, 10], [10, 10], [10, 10]], \"yellow\": [[50, 10], [93, 11], [96, 0], [120, 20], [82, 60], [10, 10]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 6, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1,3,1),(4,'{\"positions\": {\"red\": [[33, 15], [33, 15], [33, 15], [33, 15], [33, 15], [33, 15]], \"white\": [[105, 10], [105, 10], [105, 10], [105, 10], [105, 10], [105, 10]], \"yellow\": [[33, 45], [32, 13], [16, 0], [0, 25], [50, 60], [105, 10]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 6, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1,4,1),(5,'{\"positions\": {\"red\": [[90, 15], [90, 15], [90, 15], [90, 15], [90, 15], [90, 15]], \"white\": [[100, 48], [100, 48], [100, 48], [100, 48], [100, 48], [100, 48]], \"yellow\": [[60, 46], [88, 15], [91, 0], [120, 51], [108, 60], [100, 48]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 6, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1,5,1),(6,'{\"positions\": {\"red\": [[100, 11], [100, 11], [100, 11], [100, 11], [100, 11], [100, 11], [100, 11]], \"white\": [[102, 50], [102, 50], [102, 50], [102, 50], [102, 50], [102, 50], [102, 50]], \"yellow\": [[30, 11], [100, 13], [120, 28], [62, 60], [0, 17], [16, 0], [102, 50]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 7, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1,6,1),(7,'{\"positions\": {\"red\": [[40, 9], [40, 9], [40, 9], [40, 9], [40, 9], [40, 9]], \"white\": [[15, 45], [15, 45], [15, 45], [15, 45], [15, 45], [15, 45]], \"yellow\": [[95, 46], [42, 8], [45, 0], [34, 60], [27, 0], [15, 45]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 6, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1,7,1),(8,'{\"positions\": {\"red\": [[90, 15], [90, 15], [90, 15], [90, 15], [90, 15], [90, 15]], \"white\": [[41, 13], [41, 13], [41, 13], [41, 13], [41, 13], [41, 13]], \"yellow\": [[93, 43], [88, 15], [63, 0], [20, 60], [0, 44], [41, 13]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 6, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1,8,1),(9,'{\"positions\": {\"red\": [[33, 11], [33, 11], [33, 11], [33, 11], [33, 11], [33, 11]], \"white\": [[10, 14], [10, 14], [10, 14], [10, 14], [10, 14], [10, 14]], \"yellow\": [[85, 12], [46, 0], [32, 9], [17, 0], [0, 8], [10, 14]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 6, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1,9,1),(10,'{\"positions\": {\"red\": [[33, 57]], \"white\": [[40, 6]], \"yellow\": [[110, 52], [41, 60], [35, 55], [0, 14], [35, 0], [40, 6]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1,10,1),(11,'{\"positions\": {\"red\": [[15, 14]], \"white\": [[20, 18]], \"yellow\": [[45, 30], [88, 0], [120, 26], [57, 60], [0, 25], [17.5, 16]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1,11,1),(12,'{\"positions\": {\"red\": [[45, 19]], \"white\": [[35, 6]], \"yellow\": [[100, 10], [45, 17], [13, 0], [0, 9], [28, 0], [35, 6]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 1, \"sampling_rate\": 60.0}','2022-02-01 12:34:56.000000',1,12,1),(13,'{\"positions\": {\"red\": [[40, 9]], \"white\": [[15, 45]], \"yellow\": [[95, 46], [42, 8], [45, 0], [34, 60], [27, 0], [15, 45]]}, \"unix_time\": \"\", \"device_info\": 111111, \"billiard_info\": {\"board_x\": 120.0, \"board_y\": 60.0, \"ball_diameter\": 5.6}, \"num_of_frames\": 6, \"sampling_rate\": 60.0}','2022-02-02 12:34:56.000000',1,7,2);
/*!40000 ALTER TABLE `balls_route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `boards_board`
--

DROP TABLE IF EXISTS `boards_board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `boards_board` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `content` varchar(8000) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  `user_seq_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `boards_board_user_seq_id_a9110e3e_fk_accounts_user_id` (`user_seq_id`),
  CONSTRAINT `boards_board_user_seq_id_a9110e3e_fk_accounts_user_id` FOREIGN KEY (`user_seq_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `boards_board`
--

LOCK TABLES `boards_board` WRITE;
/*!40000 ALTER TABLE `boards_board` DISABLE KEYS */;
INSERT INTO `boards_board` VALUES (1,'안녕하세요','안녕하세요 첫글입니다.\n첫글을 작성하게 되서 기뻐요','2024-02-14 02:30:49.894374','2024-02-14 02:30:49.894410',0,2),(2,'손이 자꾸흔들려요','팁좀 주세요','2024-02-14 04:25:30.567524','2024-02-14 04:25:30.567561',0,2),(3,'댕댕이','고양이','2024-02-15 01:23:01.546338','2024-02-15 01:23:01.546372',0,4);
/*!40000 ALTER TABLE `boards_board` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `boards_comment`
--

DROP TABLE IF EXISTS `boards_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `boards_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` varchar(3000) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  `level` smallint DEFAULT NULL,
  `group` smallint DEFAULT NULL,
  `order` smallint DEFAULT NULL,
  `parent` int DEFAULT NULL,
  `board_seq_id` bigint NOT NULL,
  `user_seq_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `boards_comment_board_seq_id_7503d2ef_fk_boards_board_id` (`board_seq_id`),
  KEY `boards_comment_user_seq_id_63dfc08e_fk_accounts_user_id` (`user_seq_id`),
  CONSTRAINT `boards_comment_board_seq_id_7503d2ef_fk_boards_board_id` FOREIGN KEY (`board_seq_id`) REFERENCES `boards_board` (`id`),
  CONSTRAINT `boards_comment_user_seq_id_63dfc08e_fk_accounts_user_id` FOREIGN KEY (`user_seq_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `boards_comment`
--

LOCK TABLES `boards_comment` WRITE;
/*!40000 ALTER TABLE `boards_comment` DISABLE KEYS */;
INSERT INTO `boards_comment` VALUES (1,'안녕하세요','2024-02-14 04:15:21.254120','2024-02-14 04:15:21.254155',0,NULL,NULL,NULL,NULL,1,2),(2,'그렇군요','2024-02-15 01:41:40.457505','2024-02-15 01:41:40.457571',0,NULL,NULL,NULL,NULL,2,4);
/*!40000 ALTER TABLE `boards_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devices_device`
--

DROP TABLE IF EXISTS `devices_device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devices_device` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `serial_num` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_dumped` tinyint(1) NOT NULL,
  `dumpde_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices_device`
--

LOCK TABLES `devices_device` WRITE;
/*!40000 ALTER TABLE `devices_device` DISABLE KEYS */;
INSERT INTO `devices_device` VALUES (1,111111,'2022-02-01 12:34:56.000000',0,NULL),(2,222222,'2022-02-01 12:34:56.000000',0,NULL),(3,333333,'2022-02-01 12:34:56.000000',0,NULL);
/*!40000 ALTER TABLE `devices_device` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_accounts_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (19,'account','emailaddress'),(20,'account','emailconfirmation'),(6,'accounts','user'),(1,'admin','logentry'),(17,'allauth','socialaccount'),(16,'allauth','socialapp'),(18,'allauth','socialtoken'),(3,'auth','group'),(2,'auth','permission'),(14,'authtoken','token'),(15,'authtoken','tokenproxy'),(11,'balls','location'),(12,'balls','route'),(7,'boards','board'),(8,'boards','comment'),(4,'contenttypes','contenttype'),(13,'devices','device'),(10,'questions','answer'),(9,'questions','question'),(5,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2024-02-13 14:27:32.302275'),(2,'contenttypes','0002_remove_content_type_name','2024-02-13 14:27:32.397491'),(3,'auth','0001_initial','2024-02-13 14:27:32.841878'),(4,'auth','0002_alter_permission_name_max_length','2024-02-13 14:27:32.953963'),(5,'auth','0003_alter_user_email_max_length','2024-02-13 14:27:32.965392'),(6,'auth','0004_alter_user_username_opts','2024-02-13 14:27:32.975214'),(7,'auth','0005_alter_user_last_login_null','2024-02-13 14:27:32.985680'),(8,'auth','0006_require_contenttypes_0002','2024-02-13 14:27:32.991980'),(9,'auth','0007_alter_validators_add_error_messages','2024-02-13 14:27:33.002284'),(10,'auth','0008_alter_user_username_max_length','2024-02-13 14:27:33.013368'),(11,'auth','0009_alter_user_last_name_max_length','2024-02-13 14:27:33.025663'),(12,'auth','0010_alter_group_name_max_length','2024-02-13 14:27:33.051022'),(13,'auth','0011_update_proxy_permissions','2024-02-13 14:27:33.064935'),(14,'auth','0012_alter_user_first_name_max_length','2024-02-13 14:27:33.073951'),(15,'accounts','0001_initial','2024-02-13 14:27:33.580465'),(16,'account','0001_initial','2024-02-13 14:27:33.872549'),(17,'account','0002_email_max_length','2024-02-13 14:27:33.916567'),(18,'account','0003_alter_emailaddress_create_unique_verified_email','2024-02-13 14:27:33.972023'),(19,'account','0004_alter_emailaddress_drop_unique_email','2024-02-13 14:27:34.028717'),(20,'account','0005_emailaddress_idx_upper_email','2024-02-13 14:27:34.076127'),(21,'admin','0001_initial','2024-02-13 14:27:34.361235'),(22,'admin','0002_logentry_remove_auto_add','2024-02-13 14:27:34.375452'),(23,'admin','0003_logentry_add_action_flag_choices','2024-02-13 14:27:34.389319'),(24,'authtoken','0001_initial','2024-02-13 14:27:34.515288'),(25,'authtoken','0002_auto_20160226_1747','2024-02-13 14:27:34.552482'),(26,'authtoken','0003_tokenproxy','2024-02-13 14:27:34.559865'),(27,'devices','0001_initial','2024-02-13 14:27:34.595926'),(28,'balls','0001_initial','2024-02-13 14:27:34.948912'),(29,'boards','0001_initial','2024-02-13 14:27:35.304922'),(30,'questions','0001_initial','2024-02-13 14:27:35.837311'),(31,'sessions','0001_initial','2024-02-13 14:27:35.897483');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('00rq6bmhrmiwpswqrgivwug1al1695ub','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raVJi:E3uzPMXYexTZ_9HJ1cN0PBwv2b4DGr0AyYiR0zNm0U0','2024-02-29 06:33:54.917410'),('0i3mkl4fu4gi211qv2dsqoayoyqqdgn6','.eJxVjMsOwiAQRf-FtSHAMENw6d5vIMNLqoYmpV0Z_12bdKHbe865LxF4W1vYRlnClMVZWHH63SKnR-k7yHfut1mmua_LFOWuyIMOeZ1zeV4O9--g8WjfGrTT6Bmc88CmRsCSiVBHU7TSziMhKa8ITbUZlQYkALBkk-UcaxTvD6CqNkw:1raTld:8n432tn1pd63smChxw6auIU1iogcq1N2iqjp5aZ_bnA','2024-02-29 04:54:37.622051'),('0x1bcmxhprgzb9cbi30ugpdvlc39awn9','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raQHB:Jf09Sr4lIt6GIZWUGo8Il83SurUjt1qQccoVRAj0GwE','2024-02-29 01:10:57.551613'),('1j5opsl07kjcg903sr16zd5tnpkhn6rl','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raVc7:zeK0LXnJEAzJdupScMzJjGzTvyhlRjNrKxSk2umyrRc','2024-02-29 06:52:55.891162'),('2j3y99zfi0ucvqhd9l5ac6ipt31txtny','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1ra6Cx:zk6pFeIj5c3siYcGCiQBSBnQWMHRzC2AWYXkJWAYyzg','2024-02-28 03:45:15.815920'),('4wybd5zqdeeyndq5my0pp48s1jtzxy7r','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1ra8YX:6tQ-PWftMEhiY4fCfbeCgSjliOn2yIVmjtP6E3pgiy0','2024-02-28 06:15:41.504725'),('5ikqb41jia6demzwfhdgjn84c4pc0ua3','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raVGl:vi34zw5M-wkSs2N_a4fLj_5E5ipc-hJR_giY6TFjVgU','2024-02-29 06:30:51.588927'),('5xfbtv4jqcu078bzj03kijt06hhmbjae','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raQb9:WyVVC6SWRTaNBQI-gbx-Y6RjJURQ6HYMry_MYSX391U','2024-02-29 01:31:35.479243'),('66zl8m91y7est2bz0v6sr410wknd925v','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1ra3MC:kY19HfQ7-pdGbaZ0eb3HGVAfk7AjdMY2u2Npqxoyvvc','2024-02-28 00:42:36.779558'),('8103fkihnaltem78e4wzph7hfcr8fch4','.eJxVjrEOwyAMRP-FuUJAAIds7Y8gA0aJGhGpIVPVfy-JGNrNd2e_85t5POrsj51efklsYpbdfr2A8UnlDHBdT5tjjNtRKr92erzze1NU6hKxLlt59Ks_1Iz73DhO4SBV0mmwQigFEIyUApIOOmuVA4TkSGuTDKmMaEZwqBUJiopctqFB-wsXu5dS8ljZJEGAA2PB8jaOchw-X-VeSn4:1raUUm:R2sv9iqAtHiZMsnzKR74bv6OsoXM0fUDnFvaBr8T06s','2024-02-29 05:41:16.179374'),('9tb9xrsday6j2apekq60i0id0z7qk48s','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raVFt:RBPz7PltyOCIdGoI73PK7M2fVl0cRGm5ff_vkSe7UnQ','2024-02-29 06:29:57.058170'),('cg3emu8y8g5wb7lwoyjj4p6rtbwupmq4','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1ra2sC:d8c1SvWbSgAlmsh7kB_ktHe0GEaEaGtnUe45nTSZ3uY','2024-02-28 00:11:36.488150'),('dvh8z3qhdppj7xqsm4jvvq29zq9y5ldd','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raUmu:V-7XQSL081zQs7lpIlTUmwuDT4t6gBTkG76ByUvXA4E','2024-02-29 06:00:00.745220'),('el4w045775qpfki5l8cnktqcqfuqsmyc','.eJxVjMsOwiAQRf-FtSHAMENw6d5vIMNLqoYmpV0Z_12bdKHbe865LxF4W1vYRlnClMVZWHH63SKnR-k7yHfut1mmua_LFOWuyIMOeZ1zeV4O9--g8WjfGrTT6Bmc88CmRsCSiVBHU7TSziMhKa8ITbUZlQYkALBkk-UcaxTvD6CqNkw:1raQWl:t2AnSGx0UQ8UlEdzdEXihjr_-KRtq88VrCeX6WynIzc','2024-02-29 01:27:03.075919'),('fthabexnrhljeu4vkgopgb17beplcyhp','.eJxVjMsOwiAQRf-FtSEdXgMu3fsNBAaQqoGktCvjv2uTLnR7zzn3xXzY1uq3kRc_J3ZmyE6_Wwz0yG0H6R7arXPqbV3myHeFH3Twa0_5eTncv4MaRv3WgXREQOeMyC4ByhJRmAktkpDaOmWSKIVASZJgQeRSlCGjJ6HAWQns_QHHEzad:1raUmJ:Qlvymclb38aB7Tx9IrQZALjxavqg-cAY1NiUoZJrcBs','2024-02-29 05:59:23.022959'),('gma1xlwe8giqua6ek005ge6zay4yy1dv','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1ra51Q:RCV_PFsRj2jsD3WhjLQUQQ9rr9LlnBuQyVsmmjuyR9o','2024-02-28 02:29:16.499916'),('gph1hbpx9fs64jiocdtaqe01iganrhgc','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raRGJ:l7OcB4TB6zX1upclORAj77pUvz3FTvjWLFMumh3jgcY','2024-02-29 02:14:07.168949'),('gsbpbywmnx7gs2hx5a5eoi8uso534ja1','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raVc8:SBeLTX9EBwAb6RE9w9D6EcW9ZnmFfziQfOre2BVmDhs','2024-02-29 06:52:56.366571'),('gss2k9siykjpu5l6v2cn11tjsyvkoyon','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1ra9lB:iGeHnZKLiH6WhlqGTLBtF9YUQvc4IS5iC4KtYxuIim0','2024-02-28 07:32:49.955824'),('iipw6rrw6lk66l13ocetqu4fzmxo83u6','e30:1ra4uC:WrOVnTvXftUpTfFsSPVq_WPvWU_ZF2LeTQL7QOzPccE','2024-02-28 02:21:48.818154'),('jgjk6adqztz1al45obxemgedz67yiq7d','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raTCg:CYytGVPFkpptaJ4SIiDyjHVyUk5-FHqdNN3abi0kvyQ','2024-02-29 04:18:30.995017'),('jgqfizayclk58w13ezmb4c899pec4ap7','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1ra7gn:JfiGJ0dKQWwatvBcWhjVhOis5Y2y8WwMhlGDvzvZGJo','2024-02-28 05:20:09.361492'),('k1rfkw59b2t7xsgt0r5yvz39tbpha6au','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raVDk:C9znGjGQKjV49zOoTCE0Xmt2Qk0S2_PDbWdFn2_pcZg','2024-02-29 06:27:44.886133'),('ka0k4mw0aymcgzbwog6q0xy1fujl08a8','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raVBJ:tDJ3dlx2GDsn3fIco3JD6lQZN_7kjnlduR4-5p8_vcc','2024-02-29 06:25:13.863794'),('l0lwduk5r1465zjqy9kvart9fq05q5r3','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raSJl:aoysDA3eIfpd5-FOLLX1FJpY4mIa1hbRMAY4-7sjc84','2024-02-29 03:21:45.024888'),('mm2814sfoehy63uadte3t7j4ymlk0fnt','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raVBK:fedpvAEMxOrQe3LsoKPMZabENfUyZvB_fTvQ1c2kQ80','2024-02-29 06:25:14.554103'),('o0r13w8f6cechd7a12mf1wov900x0lff','e30:1ra4tY:fXgPW4xGcSOTpYPXtjvYu8Jc83SJYwH2rfXrW-BGxk8','2024-02-28 02:21:08.860974'),('obf2yxm3o4l4oqb8mwpqavog7ydjfamy','e30:1ra4tj:GFJgMOEvJ60x49cJIqSESkbWNIUOfKbYOo1yukM3U7M','2024-02-28 02:21:19.806187'),('pjbpb8oyux7b8kgefe26k5wjo7l25ty9','.eJxVjMsOwiAQRf-FtSHAMENw6d5vIMNLqoYmpV0Z_12bdKHbe865LxF4W1vYRlnClMVZWHH63SKnR-k7yHfut1mmua_LFOWuyIMOeZ1zeV4O9--g8WjfGrTT6Bmc88CmRsCSiVBHU7TSziMhKa8ITbUZlQYkALBkk-UcaxTvD6CqNkw:1raQQq:2a4b7c1XOweWq2WM34RmKIrDRabsgsFkrN_cyoHpzzs','2024-02-29 01:20:56.475398'),('pnofetp0w8w5wn0m8p6dglae10bozer3','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raU7B:7u0I0NrbojOZxrLoyqPOGrAc7UKqnilLo9PyDLHMTgk','2024-02-29 05:16:53.389690'),('rrpj62hi8uhqpxdmcpoxnoap7x6yliuh','.eJxVjMsOwiAQRf-FtSEdXgMu3fsNBAaQqoGktCvjv2uTLnR7zzn3xXzY1uq3kRc_J3ZmyE6_Wwz0yG0H6R7arXPqbV3myHeFH3Twa0_5eTncv4MaRv3WgXREQOeMyC4ByhJRmAktkpDaOmWSKIVASZJgQeRSlCGjJ6HAWQns_QHHEzad:1raUlk:AhoAU6MgOMDkcP0_oNkGGt4qIPtLG1fOXMqhH3HECRM','2024-02-29 05:58:48.399043'),('s9u36rr3gb7ccdtdloe639n0x15llcds','.eJxVjssOgyAQRf-FdUMYXgPu2h8hOEA0NZhUXDX996ph0S7vY87cNwtxb1PYt_wKc2IDQ3b79cZIz1zPIC7LafNItO618avT443fD5Vrmym2ea2PfvWHmuI2nRwyIwJ6b2X2CVCVEaUV6JCkMs5rm2QpBFqRAgcyl6ItWSOkBu8UHNA-4WL3pzmF2NgAKNCjRfAcjBVamc8XrmVJSg:1raUlb:-tUw_H5yNSzLf1Qe80UYW8kMplHWLc9d8jHNfSUMZJ4','2024-02-29 05:58:39.157480'),('uzxna4b663q7suslnh4izfe358jzw1qj','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raTCh:j40Pd6a7PoOJwS7u7UhGjClw64P-erwkBKa10gFVvVs','2024-02-29 04:18:31.492294'),('v4hllphj3lei6t8zowzcfwycif829tos','.eJxVjDsOwjAQBe_iGlnrv01JnzNY67WDA8iR4qRC3J1ESgHtzLz3ZhG3tcatlyVOmV2ZYpdflpCepR0iP7DdZ05zW5cp8SPhp-18mHN53c7276Bir_tagJGJivQkQBAYhRiEI02E3uWgrTUeAiorRyswF50kQB6d8DtJoNjnC9BKN1Y:1ra54n:DZEg9A7T7u2xMDtdIYVMYsd05ZUm4MrQzgaZeK6HD9M','2024-02-28 02:32:45.561636'),('vc2y2ol3lr9shy0thoy4muis34nn4sy3','.eJxVjkkOwyAMRe_CukKAsRHZtRdBZogSNSJSQ1ZV794kYtEu_-Dn_xaB9zaFfSuvMGcxCCtuv17k9Cz1DHhZTltySutem7w6Pd7k_VCltjlxm9f66Fd_qIm36eCAdho9g3Me2IwRsGQi1NEUrbTzSEjKK0Iz2oxKAxIAWLLJco5jPKB9wsXuT0sO3MSgnXKelAKShhyCo88XeNBI9g:1raQQW:yk9unfILaGJh46Ine0p70fvGLsoObjlNJRy68El93tc','2024-02-29 01:20:36.288574'),('x5szh7uty4jaopgfj482k3nlmj4fvzlv','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raTho:jP88AcE4m-SwqKoEjzgtKpOfNuS6zSvWja96WPn2ZMc','2024-02-29 04:50:40.359978'),('xbj1iaiopy27chvm2w1oeuituzdqdq54','.eJxVjksOgzAMBe-SdRU5H-LArr1I5DhBoKIglbCqevcCyqJdep49fm8RaK9T2Lf8CnMSgzDi9ssi8TOXM6BlObEk5nUvVV47Ld7k_ZhyqTNTndfyaFd_qom26fAo6HTkrD0rUAydIeoVsmUmj6m3znUeejJOj05RyjZqgDSi8geJcPZrFS53e5pToCoGhYAeDVotAZxxiJ8v2FNKAA:1ra3yg:sahA_oMXiDbkmDkE5Z2j7HGuI1XFmYuoBjoWgyW5_0M','2024-02-28 01:22:22.030227'),('y5bugj6vjh8ttntss9zfj7ru0opyho5v','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1raQbc:LZABjdJzu4Z1iPbCVYk-rbgOc6amOGatunl5BCUByv4','2024-02-29 01:32:04.490712'),('z93y4fmo7txa8aujmma5awm4sqxnkxjb','.eJxVjEEOwiAQRe_C2hAGpIBL956BzMBUqgaS0q6MdzckXej2v_f-W0TctxL3zmtcsrgILU6_G2F6ch0gP7Dem0ytbutCcijyoF3eWubX9XD_Dgr2MmqiwGRTUBMZY50nIq1hhmlmnYMB41xGi9YDq-RAsUI4J60tZ-M9iM8X8fI3vQ:1ra4yn:pcmtQlWirUJHDD5Mk2Q1EgrUmRDF1VsUHc3UwUxneIY','2024-02-28 02:26:33.762075');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions_answer`
--

DROP TABLE IF EXISTS `questions_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions_answer` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` varchar(3000) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  `difficulty` int DEFAULT NULL,
  `question_seq_id` bigint NOT NULL,
  `route_seq_id` bigint NOT NULL,
  `user_seq_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `questions_answer_question_seq_id_03b7e0d2_fk_questions` (`question_seq_id`),
  KEY `questions_answer_route_seq_id_05da349e_fk_balls_route_id` (`route_seq_id`),
  KEY `questions_answer_user_seq_id_14471b38_fk_accounts_user_id` (`user_seq_id`),
  CONSTRAINT `questions_answer_question_seq_id_03b7e0d2_fk_questions` FOREIGN KEY (`question_seq_id`) REFERENCES `questions_question` (`id`),
  CONSTRAINT `questions_answer_route_seq_id_05da349e_fk_balls_route_id` FOREIGN KEY (`route_seq_id`) REFERENCES `balls_route` (`id`),
  CONSTRAINT `questions_answer_user_seq_id_14471b38_fk_accounts_user_id` FOREIGN KEY (`user_seq_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions_answer`
--

LOCK TABLES `questions_answer` WRITE;
/*!40000 ALTER TABLE `questions_answer` DISABLE KEYS */;
INSERT INTO `questions_answer` VALUES (1,'Try this','2024-02-14 04:49:11.219887','2024-02-14 04:49:11.219925',0,6,1,10,3),(2,'이렇게 치시면 될거같아요','2024-02-15 01:39:41.776960','2024-02-15 01:39:41.776996',0,4,5,13,2);
/*!40000 ALTER TABLE `questions_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions_question`
--

DROP TABLE IF EXISTS `questions_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions_question` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `content` varchar(8000) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  `location_seq_id` bigint NOT NULL,
  `user_seq_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `questions_question_location_seq_id_a38df19d_fk_balls_location_id` (`location_seq_id`),
  KEY `questions_question_user_seq_id_4769ba79_fk_accounts_user_id` (`user_seq_id`),
  CONSTRAINT `questions_question_location_seq_id_a38df19d_fk_balls_location_id` FOREIGN KEY (`location_seq_id`) REFERENCES `balls_location` (`id`),
  CONSTRAINT `questions_question_user_seq_id_4769ba79_fk_accounts_user_id` FOREIGN KEY (`user_seq_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions_question`
--

LOCK TABLES `questions_question` WRITE;
/*!40000 ALTER TABLE `questions_question` DISABLE KEYS */;
INSERT INTO `questions_question` VALUES (1,'Question','please help me!\ni\'m talking stone\nI\'m just potato','2024-02-14 04:47:34.100053','2024-02-14 04:47:34.100090',0,10,3),(2,'도움!','어디로 쳐야될지 모르겠어요\n도와주세요ㅠㅠ','2024-02-14 07:36:12.064043','2024-02-14 07:36:12.064079',0,11,2),(4,'질문!!','쉬워보였는데 생각보다 잘 안되네요ㅠ\n\n어느방향에서 시작하는게 좋을까요?','2024-02-14 10:35:32.858421','2024-02-14 10:35:32.858457',0,8,2),(5,'경로 팁 주세요','어떻게 쳐야할지 모르겠어요','2024-02-15 01:29:09.543904','2024-02-15 01:29:09.543938',0,10,4);
/*!40000 ALTER TABLE `questions_question` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-02-15  8:15:36
