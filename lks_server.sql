-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 21, 2026 at 01:14 AM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lks_server`
--

-- --------------------------------------------------------

--
-- Table structure for table `administrators`
--

CREATE TABLE `administrators` (
  `id` bigint UNSIGNED NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `administrators`
--

INSERT INTO `administrators` (`id`, `username`, `password`, `last_login_at`, `created_at`, `updated_at`) VALUES
(1, 'admin1', '$2y$12$OBHV.xdfXnG/i9NIxWwVHO4Axz7igoy51.de21y5Av3yoQR97LhOy', NULL, '2026-04-19 20:12:11', '2026-04-19 20:12:11');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `thumbnail` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` bigint UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`id`, `title`, `slug`, `description`, `thumbnail`, `created_by`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'Demo Game 1 (updated)', 'demo-game-1', 'This is demo game 1 (updated)', '/games/demo-game-1/v4/thumbnail.png', 1, NULL, '2024-04-09 08:32:41', '2026-04-19 21:03:37'),
(3, 'Demo Game 3', 'demo-game-3', 'This is demo game 3', NULL, 1, NULL, '2024-04-09 09:45:29', '2024-04-09 09:45:29'),
(4, 'Demo Game 4', 'demo-game-4', 'This is demo game 4', NULL, 1, NULL, '2024-04-09 10:43:25', '2024-04-09 10:43:25'),
(5, 'Demo Game 5', 'demo-game-5', 'This is demo game 5', NULL, 1, NULL, '2024-04-09 10:41:21', '2024-04-09 10:41:21'),
(6, 'Demo Game 6', 'demo-game-6', 'This is demo game 6', NULL, 1, NULL, '2024-04-09 10:39:17', '2024-04-09 10:39:17'),
(7, 'Demo Game 7', 'demo-game-7', 'This is demo game 7', NULL, 1, NULL, '2024-04-09 10:37:13', '2024-04-09 10:37:13'),
(8, 'Demo Game 8', 'demo-game-8', 'This is demo game 8', NULL, 1, NULL, '2024-04-09 11:35:09', '2024-04-09 11:35:09'),
(9, 'Demo Game 9', 'demo-game-9', 'This is demo game 9', NULL, 1, NULL, '2024-04-09 11:33:05', '2024-04-09 11:33:05'),
(10, 'Demo Game 10', 'demo-game-10', 'This is demo game 10', NULL, 1, NULL, '2024-04-09 11:31:01', '2024-04-09 11:31:01'),
(11, 'Demo Game 11', 'demo-game-11', 'This is demo game 11', NULL, 1, NULL, '2024-04-09 11:28:57', '2024-04-09 11:28:57'),
(12, 'Demo Game 12', 'demo-game-12', 'This is demo game 12', NULL, 1, NULL, '2024-04-09 12:26:53', '2024-04-09 12:26:53'),
(13, 'Demo Game 13', 'demo-game-13', 'This is demo game 13', NULL, 1, NULL, '2024-04-09 12:24:49', '2024-04-09 12:24:49'),
(14, 'Demo Game 14', 'demo-game-14', 'This is demo game 14', NULL, 1, NULL, '2024-04-09 12:22:45', '2024-04-09 12:22:45'),
(15, 'Demo Game 15', 'demo-game-15', 'This is demo game 15', NULL, 1, NULL, '2024-04-09 12:20:41', '2024-04-09 12:20:41'),
(16, 'Demo Game 16', 'demo-game-16', 'This is demo game 16', NULL, 4, NULL, '2024-04-09 13:18:37', '2024-04-09 13:18:37'),
(17, 'Demo Game 17', 'demo-game-17', 'This is demo game 17', NULL, 4, NULL, '2024-04-09 13:16:33', '2024-04-09 13:16:33'),
(18, 'Demo Game 18', 'demo-game-18', 'This is demo game 18', NULL, 4, NULL, '2024-04-09 13:14:29', '2024-04-09 13:14:29'),
(19, 'Demo Game 19', 'demo-game-19', 'This is demo game 19', NULL, 4, NULL, '2024-04-09 13:12:25', '2024-04-09 13:12:25'),
(20, 'Demo Game 20', 'demo-game-20', 'This is demo game 20', NULL, 4, NULL, '2024-04-09 14:10:21', '2024-04-09 14:10:21'),
(21, 'Demo Game 21', 'demo-game-21', 'This is demo game 21', NULL, 4, NULL, '2024-04-09 14:08:17', '2024-04-09 14:08:17'),
(22, 'Demo Game 22', 'demo-game-22', 'This is demo game 22', NULL, 4, NULL, '2024-04-09 14:06:13', '2024-04-09 14:06:13'),
(23, 'Demo Game 23', 'demo-game-23', 'This is demo game 23', NULL, 4, NULL, '2024-04-09 14:04:09', '2024-04-09 14:04:09'),
(24, 'Demo Game 24', 'demo-game-24', 'This is demo game 24', NULL, 4, NULL, '2024-04-09 15:02:05', '2024-04-09 15:02:05'),
(25, 'Demo Game 25', 'demo-game-25', 'This is demo game 25', NULL, 4, NULL, '2024-04-09 15:00:01', '2024-04-09 15:00:01'),
(26, 'Demo Game 26', 'demo-game-26', 'This is demo game 26', NULL, 4, NULL, '2024-04-09 14:57:57', '2024-04-09 14:57:57'),
(27, 'Demo Game 27', 'demo-game-27', 'This is demo game 27', NULL, 4, NULL, '2024-04-09 14:55:53', '2024-04-09 14:55:53'),
(28, 'Demo Game 28', 'demo-game-28', 'This is demo game 28', NULL, 4, NULL, '2024-04-09 15:53:49', '2024-04-09 15:53:49'),
(29, 'Demo Game 29', 'demo-game-29', 'This is demo game 29', NULL, 4, NULL, '2024-04-09 15:51:45', '2024-04-09 15:51:45'),
(30, 'Demo Game 30', 'demo-game-30', 'This is demo game 30', NULL, 4, NULL, '2024-04-09 15:49:41', '2024-04-09 15:49:41'),
(31, 'My New Game', 'my-new-game', 'This is my newest game, it is awesome', NULL, 1, NULL, '2026-04-19 20:19:36', '2026-04-19 20:19:36');

-- --------------------------------------------------------

--
-- Table structure for table `game_versions`
--

CREATE TABLE `game_versions` (
  `id` bigint UNSIGNED NOT NULL,
  `game_id` bigint UNSIGNED NOT NULL,
  `storage_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `game_versions`
--

INSERT INTO `game_versions` (`id`, `game_id`, `storage_path`, `version`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'games/1/v1/', 'v1', '2024-04-09 08:45:41', '2024-04-09 08:32:41', '2024-04-09 08:32:41'),
(2, 1, 'games/1/v2/', 'v2', NULL, '2024-04-09 08:45:41', '2024-04-09 08:45:41'),
(4, 3, 'games/3/v1/', 'v1', NULL, '2024-04-09 09:45:29', '2024-04-09 09:45:29'),
(5, 4, 'games/4/v1/', 'v1', NULL, '2024-04-09 10:43:25', '2024-04-09 10:43:25'),
(6, 5, 'games/5/v1/', 'v1', NULL, '2024-04-09 10:41:21', '2024-04-09 10:41:21'),
(7, 6, 'games/6/v1/', 'v1', NULL, '2024-04-09 10:39:17', '2024-04-09 10:39:17'),
(8, 7, 'games/7/v1/', 'v1', NULL, '2024-04-09 10:37:13', '2024-04-09 10:37:13'),
(9, 8, 'games/8/v1/', 'v1', NULL, '2024-04-09 11:35:09', '2024-04-09 11:35:09'),
(10, 9, 'games/9/v1/', 'v1', NULL, '2024-04-09 11:33:05', '2024-04-09 11:33:05'),
(11, 10, 'games/10/v1/', 'v1', NULL, '2024-04-09 11:31:01', '2024-04-09 11:31:01'),
(12, 11, 'games/11/v1/', 'v1', NULL, '2024-04-09 11:28:57', '2024-04-09 11:28:57'),
(13, 12, 'games/12/v1/', 'v1', NULL, '2024-04-09 12:26:53', '2024-04-09 12:26:53'),
(14, 13, 'games/13/v1/', 'v1', NULL, '2024-04-09 12:24:49', '2024-04-09 12:24:49'),
(15, 14, 'games/14/v1/', 'v1', NULL, '2024-04-09 12:22:45', '2024-04-09 12:22:45'),
(16, 15, 'games/15/v1/', 'v1', NULL, '2024-04-09 12:20:41', '2024-04-09 12:20:41'),
(17, 16, 'games/16/v1/', 'v1', NULL, '2024-04-09 13:18:37', '2024-04-09 13:18:37'),
(18, 17, 'games/17/v1/', 'v1', NULL, '2024-04-09 13:16:33', '2024-04-09 13:16:33'),
(19, 18, 'games/18/v1/', 'v1', NULL, '2024-04-09 13:14:29', '2024-04-09 13:14:29'),
(20, 19, 'games/19/v1/', 'v1', NULL, '2024-04-09 13:12:25', '2024-04-09 13:12:25'),
(21, 20, 'games/20/v1/', 'v1', NULL, '2024-04-09 14:10:21', '2024-04-09 14:10:21'),
(22, 21, 'games/21/v1/', 'v1', NULL, '2024-04-09 14:08:17', '2024-04-09 14:08:17'),
(23, 22, 'games/22/v1/', 'v1', NULL, '2024-04-09 14:06:13', '2024-04-09 14:06:13'),
(24, 23, 'games/23/v1/', 'v1', NULL, '2024-04-09 14:04:09', '2024-04-09 14:04:09'),
(25, 24, 'games/24/v1/', 'v1', NULL, '2024-04-09 15:02:05', '2024-04-09 15:02:05'),
(26, 25, 'games/25/v1/', 'v1', NULL, '2024-04-09 15:00:01', '2024-04-09 15:00:01'),
(27, 26, 'games/26/v1/', 'v1', NULL, '2024-04-09 14:57:57', '2024-04-09 14:57:57'),
(28, 27, 'games/27/v1/', 'v1', NULL, '2024-04-09 14:55:53', '2024-04-09 14:55:53'),
(29, 28, 'games/28/v1/', 'v1', NULL, '2024-04-09 15:53:49', '2024-04-09 15:53:49'),
(30, 29, 'games/29/v1/', 'v1', NULL, '2024-04-09 15:51:45', '2024-04-09 15:51:45'),
(31, 30, 'games/30/v1/', 'v1', NULL, '2024-04-09 15:49:41', '2024-04-09 15:49:41'),
(32, 1, 'games/demo-game-1/v3/', 'v3', NULL, '2026-04-19 21:03:27', '2026-04-19 21:03:27'),
(33, 1, 'games/demo-game-1/v4/', 'v4', NULL, '2026-04-19 21:03:37', '2026-04-19 21:03:37');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_04_20_014300_create_games_table', 1),
(5, '2026_04_20_014400_create_game_versions_table', 1),
(6, '2026_04_20_014420_create_administrators_table', 1),
(7, '2026_04_20_014609_create_scores_table', 1),
(8, '2026_04_20_014823_create_personal_access_tokens_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\Administrator', 1, 'auth_token', '5824ced34c941e0f3eda39d440d5029c618c3fb30758c54bda2f6fb151685c09', '[\"*\"]', '2026-04-19 21:20:01', NULL, '2026-04-19 20:15:41', '2026-04-19 21:20:01'),
(2, 'App\\Models\\User', 2, 'auth_token', '3a1b56605e341bce66b7f7ab7d2ddb603ade3c82245808c69f4fc38d95c599b0', '[\"*\"]', '2026-04-19 21:24:08', NULL, '2026-04-19 21:19:21', '2026-04-19 21:24:08'),
(6, 'App\\Models\\Administrator', 1, 'auth_token', '461e97d459e228ea0b0d4c0495860f37e5b2a1bc95a07707b517dff104f32c06', '[\"*\"]', '2026-04-20 18:13:44', NULL, '2026-04-20 00:28:59', '2026-04-20 18:13:44'),
(7, 'App\\Models\\User', 2, 'auth_token', '3ddc7f12a7f9bd8b4adbb3210c985669f9f9f64345d3ae41ea61ee6041a54919', '[\"*\"]', '2026-04-20 00:57:39', NULL, '2026-04-20 00:57:13', '2026-04-20 00:57:39');

-- --------------------------------------------------------

--
-- Table structure for table `scores`
--

CREATE TABLE `scores` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `game_version_id` bigint UNSIGNED NOT NULL,
  `score` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `scores`
--

INSERT INTO `scores` (`id`, `user_id`, `game_version_id`, `score`, `created_at`, `updated_at`) VALUES
(1, 1, 33, '1234.00', '2026-04-19 21:19:01', '2026-04-19 21:19:01'),
(2, 2, 33, '1234.00', '2026-04-19 21:19:57', '2026-04-19 21:19:57');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `delete_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `last_login_at`, `remember_token`, `created_at`, `updated_at`, `deleted_at`, `delete_reason`) VALUES
(1, 'dev1', '$2y$12$ZWqBd7v/8f1OtgXtYt5YMONQ9HGj7izbjXhSdJq8/Ft3Bhz8lxBRa', NULL, NULL, '2026-04-19 20:12:11', '2026-04-19 20:12:11', NULL, NULL),
(2, 'play1', '$2y$12$fsNClmX1G491pwRtGeaIVel3ZJKYc9Hv7GfIfla2seH1fMrFVdNg.', NULL, NULL, '2026-04-19 20:12:11', '2026-04-19 20:12:11', NULL, NULL),
(3, 'dev133', '$2y$12$B.Vd7Z8s1dpwq3N1O537ceEGHWliNi7453Bqdsau1RzYtSM6J1BcW', NULL, NULL, '2026-04-19 23:53:07', '2026-04-19 23:53:07', NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `administrators`
--
ALTER TABLE `administrators`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`id`),
  ADD KEY `games_created_by_foreign` (`created_by`);

--
-- Indexes for table `game_versions`
--
ALTER TABLE `game_versions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `game_versions_game_id_foreign` (`game_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `scores`
--
ALTER TABLE `scores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `scores_user_id_foreign` (`user_id`),
  ADD KEY `scores_game_version_id_foreign` (`game_version_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `administrators`
--
ALTER TABLE `administrators`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `game_versions`
--
ALTER TABLE `game_versions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `scores`
--
ALTER TABLE `scores`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `games`
--
ALTER TABLE `games`
  ADD CONSTRAINT `games_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `game_versions`
--
ALTER TABLE `game_versions`
  ADD CONSTRAINT `game_versions_game_id_foreign` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `scores`
--
ALTER TABLE `scores`
  ADD CONSTRAINT `scores_game_version_id_foreign` FOREIGN KEY (`game_version_id`) REFERENCES `game_versions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `scores_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
