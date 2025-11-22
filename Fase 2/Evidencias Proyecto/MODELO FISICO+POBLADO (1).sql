/*
 Navicat Premium Data Transfer

 Source Server         : LOCAL_PC
 Source Server Type    : MySQL
 Source Server Version : 100411
 Source Host           : localhost:3306
 Source Schema         : smart

 Target Server Type    : MySQL
 Target Server Version : 100411
 File Encoding         : 65001

 Date: 26/06/2023 02:03:33
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for announcements
-- ----------------------------
DROP TABLE IF EXISTS `announcements`;
CREATE TABLE `announcements`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_announcement_user` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `announcements_id_announcement_user_foreign`(`id_announcement_user`) USING BTREE,
  CONSTRAINT `announcements_id_announcement_user_foreign` FOREIGN KEY (`id_announcement_user`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for customer
-- ----------------------------
DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mother_last_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `identification_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `customer_email_unique`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for failed_jobs
-- ----------------------------
DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp(0) NOT NULL DEFAULT current_timestamp(0),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `failed_jobs_uuid_unique`(`uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for migrations
-- ----------------------------
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 135 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for nps
-- ----------------------------
DROP TABLE IF EXISTS `nps`;
CREATE TABLE `nps`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `id_customer` bigint(20) UNSIGNED NOT NULL,
  `id_ticket` bigint(20) UNSIGNED NOT NULL,
  `evaluation` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `nps_id_user_foreign`(`id_user`) USING BTREE,
  INDEX `nps_id_customer_foreign`(`id_customer`) USING BTREE,
  INDEX `nps_id_ticket_foreign`(`id_ticket`) USING BTREE,
  CONSTRAINT `nps_id_customer_foreign` FOREIGN KEY (`id_customer`) REFERENCES `customer` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `nps_id_ticket_foreign` FOREIGN KEY (`id_ticket`) REFERENCES `tickets` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `nps_id_user_foreign` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for personal_access_tokens
-- ----------------------------
DROP TABLE IF EXISTS `personal_access_tokens`;
CREATE TABLE `personal_access_tokens`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `last_used_at` timestamp(0) NULL DEFAULT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `personal_access_tokens_token_unique`(`token`) USING BTREE,
  INDEX `personal_access_tokens_tokenable_type_tokenable_id_index`(`tokenable_type`, `tokenable_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for positions
-- ----------------------------
DROP TABLE IF EXISTS `positions`;
CREATE TABLE `positions`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `positions_id_user_foreign`(`id_user`) USING BTREE,
  CONSTRAINT `positions_id_user_foreign` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tickets
-- ----------------------------
DROP TABLE IF EXISTS `tickets`;
CREATE TABLE `tickets`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_managing_user` bigint(20) UNSIGNED NOT NULL,
  `id_status` bigint(20) UNSIGNED NOT NULL,
  `id_type` bigint(20) UNSIGNED NOT NULL,
  `id_category` bigint(20) UNSIGNED NOT NULL,
  `id_priority` bigint(20) UNSIGNED NOT NULL,
  `id_customer` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `latitude` double NULL DEFAULT NULL,
  `longitude` double NULL DEFAULT NULL,
  `fecha_ingreso_solicitud` datetime(0) NULL DEFAULT NULL,
  `fecha_realizar_servicio` datetime(0) NULL DEFAULT NULL,
  `fecha_termino_servicio` datetime(0) NULL DEFAULT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `tickets_id_managing_user_foreign`(`id_managing_user`) USING BTREE,
  INDEX `tickets_id_status_foreign`(`id_status`) USING BTREE,
  INDEX `tickets_id_type_foreign`(`id_type`) USING BTREE,
  INDEX `tickets_id_category_foreign`(`id_category`) USING BTREE,
  INDEX `tickets_id_priority_foreign`(`id_priority`) USING BTREE,
  INDEX `tickets_id_customer_foreign`(`id_customer`) USING BTREE,
  CONSTRAINT `tickets_id_category_foreign` FOREIGN KEY (`id_category`) REFERENCES `tickets_category` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `tickets_id_customer_foreign` FOREIGN KEY (`id_customer`) REFERENCES `customer` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `tickets_id_managing_user_foreign` FOREIGN KEY (`id_managing_user`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `tickets_id_priority_foreign` FOREIGN KEY (`id_priority`) REFERENCES `tickets_priority` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `tickets_id_status_foreign` FOREIGN KEY (`id_status`) REFERENCES `tickets_status` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `tickets_id_type_foreign` FOREIGN KEY (`id_type`) REFERENCES `tickets_type` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tickets_category
-- ----------------------------
DROP TABLE IF EXISTS `tickets_category`;
CREATE TABLE `tickets_category`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tickets_category
-- ----------------------------
INSERT INTO `tickets_category` VALUES (1, 'Trabajo', NULL, NULL, NULL);
INSERT INTO `tickets_category` VALUES (2, 'Personal', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for tickets_priority
-- ----------------------------
DROP TABLE IF EXISTS `tickets_priority`;
CREATE TABLE `tickets_priority`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tickets_priority
-- ----------------------------
INSERT INTO `tickets_priority` VALUES (1, 'Baja', NULL, NULL, NULL);
INSERT INTO `tickets_priority` VALUES (2, 'Media', NULL, NULL, NULL);
INSERT INTO `tickets_priority` VALUES (3, 'Alta', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for tickets_status
-- ----------------------------
DROP TABLE IF EXISTS `tickets_status`;
CREATE TABLE `tickets_status`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tickets_status
-- ----------------------------
INSERT INTO `tickets_status` VALUES (1, 'Pendiente', NULL, NULL, NULL);
INSERT INTO `tickets_status` VALUES (2, 'Activo', NULL, NULL, NULL);
INSERT INTO `tickets_status` VALUES (3, 'Terminado', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for tickets_type
-- ----------------------------
DROP TABLE IF EXISTS `tickets_type`;
CREATE TABLE `tickets_type`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tickets_type
-- ----------------------------
INSERT INTO `tickets_type` VALUES (1, 'Ticket', NULL, NULL, NULL);
INSERT INTO `tickets_type` VALUES (2, 'Cita', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `id_user_type` bigint(20) UNSIGNED NOT NULL,
  `id_vehicle` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mother_last_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `identification_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `gender` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'M or F',
  `birth_date` date NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp(0) NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `users_email_unique`(`email`) USING BTREE,
  INDEX `users_id_user_type_foreign`(`id_user_type`) USING BTREE,
  INDEX `users_id_vehicle_foreign`(`id_vehicle`) USING BTREE,
  CONSTRAINT `users_id_user_type_foreign` FOREIGN KEY (`id_user_type`) REFERENCES `users_type` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `users_id_vehicle_foreign` FOREIGN KEY (`id_vehicle`) REFERENCES `vehicles` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 1, 1, NULL, 'Benjamín', 'Araya', NULL, NULL, NULL, NULL, NULL, 'benjamin@smarttechnical.com', NULL, '$2y$10$iaRXYkHtwEdQFygrYDvvHeolkDdehqRDmSKaKSVRwOEj5Y0LEElp6', NULL, NULL, NULL);
INSERT INTO `users` VALUES (2, 1, 1, NULL, 'Isadora', 'Henriquez', NULL, NULL, NULL, NULL, NULL, 'isadora@smarttechnical.com', NULL, '$2y$10$EcQXEiOa5nbNX5xeCpGkbOQuYOhXJd9etAhv8s3l0MgODeF0nxQ3W', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for users_type
-- ----------------------------
DROP TABLE IF EXISTS `users_type`;
CREATE TABLE `users_type`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users_type
-- ----------------------------
INSERT INTO `users_type` VALUES (1, 'Administrador/a', 'Rol de administrador del sistema', NULL, NULL);
INSERT INTO `users_type` VALUES (2, 'Técnico/a', 'Rol de técnico de mantenimiento', NULL, NULL);
INSERT INTO `users_type` VALUES (3, 'Secretario/a', 'Rol de secretario/a del sistema', NULL, NULL);

-- ----------------------------
-- Table structure for vehicles
-- ----------------------------
DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE `vehicles`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_vehicle_model` bigint(20) UNSIGNED NOT NULL,
  `is_busy` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `plate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `vehicles_id_vehicle_model_foreign`(`id_vehicle_model`) USING BTREE,
  CONSTRAINT `vehicles_id_vehicle_model_foreign` FOREIGN KEY (`id_vehicle_model`) REFERENCES `vehicles_model` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for vehicles_brand
-- ----------------------------
DROP TABLE IF EXISTS `vehicles_brand`;
CREATE TABLE `vehicles_brand`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of vehicles_brand
-- ----------------------------
INSERT INTO `vehicles_brand` VALUES (1, 'Toyota', NULL, NULL);
INSERT INTO `vehicles_brand` VALUES (2, 'Chevrolet', NULL, NULL);
INSERT INTO `vehicles_brand` VALUES (3, 'Nissan', NULL, NULL);

-- ----------------------------
-- Table structure for vehicles_model
-- ----------------------------
DROP TABLE IF EXISTS `vehicles_model`;
CREATE TABLE `vehicles_model`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_vehicles_brand` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `vehicles_model_id_vehicles_brand_foreign`(`id_vehicles_brand`) USING BTREE,
  CONSTRAINT `vehicles_model_id_vehicles_brand_foreign` FOREIGN KEY (`id_vehicles_brand`) REFERENCES `vehicles_brand` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of vehicles_model
-- ----------------------------
INSERT INTO `vehicles_model` VALUES (1, 1, 'Yaris', NULL, NULL);
INSERT INTO `vehicles_model` VALUES (2, 1, 'Corolla', NULL, NULL);
INSERT INTO `vehicles_model` VALUES (3, 1, 'Rav4', NULL, NULL);
INSERT INTO `vehicles_model` VALUES (4, 1, 'Hilux', NULL, NULL);
INSERT INTO `vehicles_model` VALUES (5, 1, 'Land Cruiser', NULL, NULL);
INSERT INTO `vehicles_model` VALUES (6, 2, 'Spark', NULL, NULL);
INSERT INTO `vehicles_model` VALUES (7, 2, 'Cruze', NULL, NULL);
INSERT INTO `vehicles_model` VALUES (8, 2, 'Trax', NULL, NULL);
INSERT INTO `vehicles_model` VALUES (9, 2, 'Equinox', NULL, NULL);
INSERT INTO `vehicles_model` VALUES (10, 2, 'Silverado', NULL, NULL);
INSERT INTO `vehicles_model` VALUES (11, 3, 'Versa', NULL, NULL);
INSERT INTO `vehicles_model` VALUES (12, 3, 'Sentra', NULL, NULL);
INSERT INTO `vehicles_model` VALUES (13, 3, 'X-Trail', NULL, NULL);
INSERT INTO `vehicles_model` VALUES (14, 3, 'Kicks', NULL, NULL);
INSERT INTO `vehicles_model` VALUES (15, 3, 'Frontier', NULL, NULL);

-- ----------------------------
-- Triggers structure for table users
-- ----------------------------
DROP TRIGGER IF EXISTS `update_vehicle_status`;
delimiter ;;
CREATE TRIGGER `update_vehicle_status` AFTER INSERT ON `users` FOR EACH ROW BEGIN
        IF NEW.id_vehicle IS NOT NULL THEN
            UPDATE vehicles SET is_busy = 1 WHERE id = NEW.id_vehicle;
        END IF;
    END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table users
-- ----------------------------
DROP TRIGGER IF EXISTS `update_vehicle_status_after_update`;
delimiter ;;
CREATE TRIGGER `update_vehicle_status_after_update` AFTER UPDATE ON `users` FOR EACH ROW BEGIN
        IF NEW.id_vehicle IS NOT NULL THEN
            UPDATE vehicles SET is_busy = 1 WHERE id = NEW.id_vehicle;
        END IF;
    END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
