-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 08 Jun 2025 pada 12.43
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_latihan`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `barang`
--

CREATE TABLE `barang` (
  `id` int(10) NOT NULL,
  `gambar` varchar(255) NOT NULL,
  `nama_barang` varchar(255) NOT NULL,
  `stok` int(11) NOT NULL,
  `harga` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `barang`
--

INSERT INTO `barang` (`id`, `gambar`, `nama_barang`, `stok`, `harga`, `created_at`, `updated_at`) VALUES
(7, '1749295606_ryzen7700.jpg', 'CPU Ryzen 7700', 5, 3000, '2025-06-07 04:26:46', '2025-06-08 03:09:11'),
(8, '1749295639_i514400f.jpg', 'CPU I5 14400F', 3, 2000, '2025-06-07 04:27:19', '2025-06-08 03:09:27'),
(9, '1749295671_rx6600.jpg', 'RX 6600', 5, 4000, '2025-06-07 04:27:51', '2025-06-07 04:27:51'),
(10, '1749295700_5090.jpg', 'RTX 5090', 3, 10000, '2025-06-07 04:28:20', '2025-06-07 04:28:20'),
(11, '1749295737_rx580.jpg', 'RX 580', 30, 1500, '2025-06-07 04:28:57', '2025-06-07 04:28:57'),
(12, '1749295781_3050.jpg', 'RTX 3050', 15, 2000, '2025-06-07 04:29:41', '2025-06-07 04:29:41'),
(13, '1749295808_rx7700xt.jpg', 'RX 7700XT', 5, 7000, '2025-06-07 04:30:08', '2025-06-07 19:30:19'),
(16, '1749348656_5060ti.jpg', 'RTX 5060TI', 10, 6000, '2025-06-07 19:10:56', '2025-06-08 03:33:21');

-- --------------------------------------------------------

--
-- Struktur dari tabel `beli`
--

CREATE TABLE `beli` (
  `id` int(10) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `id_payment` int(11) DEFAULT NULL,
  `tanggal_beli` date NOT NULL,
  `jumlah` int(11) NOT NULL,
  `total` int(11) NOT NULL,
  `status` enum('paid','unpaid','expired','cancel') NOT NULL DEFAULT 'unpaid',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `beli`
--

INSERT INTO `beli` (`id`, `id_user`, `id_barang`, `id_payment`, `tanggal_beli`, `jumlah`, `total`, `status`, `created_at`, `updated_at`) VALUES
(40, 3, 11, 34, '2025-06-07', 3, 4500, 'expired', '2025-06-07 04:37:16', '2025-06-07 05:02:39'),
(42, 3, 10, 35, '2025-06-07', 1, 10000, 'unpaid', '2025-06-07 04:38:20', '2025-06-07 04:38:21'),
(43, 3, 8, 36, '2025-06-07', 3, 6000, 'cancel', '2025-06-07 05:03:27', '2025-06-08 03:39:27'),
(44, 3, 13, 37, '2025-06-07', 1, 7000, 'paid', '2025-06-07 05:40:32', '2025-06-07 05:42:54'),
(110, 3, 16, 47, '2025-06-08', 5, 30000, 'paid', '2025-06-08 03:13:20', '2025-06-08 03:16:22'),
(118, 3, 7, NULL, '2025-06-08', 1, 3000, 'unpaid', '2025-06-08 03:40:36', '2025-06-08 03:40:36'),
(119, 3, 8, 51, '2025-06-08', 1, 2000, 'unpaid', '2025-06-08 03:41:47', '2025-06-08 03:41:48');

--
-- Trigger `beli`
--
DELIMITER $$
CREATE TRIGGER `beli` AFTER UPDATE ON `beli` FOR EACH ROW BEGIN
IF new.status = 'paid' AND old.status != new.status THEN UPDATE barang SET stok = stok - new.jumlah WHERE id = new.id_barang;
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_06_02_115251_create_personal_access_tokens_table', 1),
(5, '2025_06_03_110758_create_barangs_table', 2),
(6, '2025_06_05_111835_create_belis_table', 3),
(7, '2025_06_05_133051_create_payments_table', 4);

-- --------------------------------------------------------

--
-- Struktur dari tabel `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `payment`
--

CREATE TABLE `payment` (
  `id` int(10) NOT NULL,
  `id_beli` int(11) NOT NULL,
  `transaction_id` varchar(255) NOT NULL,
  `order_id` varchar(255) NOT NULL,
  `payment_type` varchar(255) NOT NULL,
  `merchant_id` varchar(255) NOT NULL,
  `gross_amount` varchar(255) NOT NULL,
  `transaction_time` datetime DEFAULT NULL,
  `expiry_time` datetime DEFAULT NULL,
  `settlement_time` datetime DEFAULT NULL,
  `transaction_status` enum('pending','settlement','cancel','expire') NOT NULL,
  `payment_code` varchar(255) DEFAULT NULL,
  `qr_code` varchar(255) DEFAULT NULL,
  `bank` varchar(255) DEFAULT NULL,
  `store` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `payment`
--

INSERT INTO `payment` (`id`, `id_beli`, `transaction_id`, `order_id`, `payment_type`, `merchant_id`, `gross_amount`, `transaction_time`, `expiry_time`, `settlement_time`, `transaction_status`, `payment_code`, `qr_code`, `bank`, `store`, `created_at`, `updated_at`) VALUES
(34, 40, '0fde9923-8d93-4e4c-a35f-9fda4432a733', '40', 'gopay', 'G276526701', '4500.00', '2025-06-07 18:37:26', '2025-06-07 18:52:26', NULL, 'expire', NULL, 'https://api.sandbox.midtrans.com/v2/gopay/0fde9923-8d93-4e4c-a35f-9fda4432a733/qr-code', NULL, NULL, '2025-06-07 04:37:23', '2025-06-07 05:02:39'),
(35, 42, 'e14d1a99-9dd0-41ad-84ef-e68c85091a09', '42', 'bank_transfer', 'G276526701', '10000.00', '2025-06-07 18:38:24', '2025-06-08 18:38:20', NULL, 'pending', '26701906405271543504942', NULL, 'bca', NULL, '2025-06-07 04:38:21', '2025-06-07 04:38:21'),
(36, 43, '75a7d551-debe-496a-945d-378460d9215e', '43', 'cstore', 'G276526701', '6000.00', '2025-06-07 19:03:31', '2025-06-08 19:03:31', NULL, 'cancel', '2765117276716812', NULL, NULL, 'alfamart', '2025-06-07 05:03:28', '2025-06-08 03:39:27'),
(37, 44, '7ec7e76d-168d-498c-8646-5723a5724d15', '44', 'gopay', 'G276526701', '7000.00', '2025-06-07 19:40:36', '2025-06-07 19:55:35', '2025-06-07 19:40:49', 'settlement', NULL, 'https://api.sandbox.midtrans.com/v2/gopay/7ec7e76d-168d-498c-8646-5723a5724d15/qr-code', NULL, NULL, '2025-06-07 05:40:32', '2025-06-07 05:42:54'),
(47, 110, 'a41db644-cbbb-4d61-900b-205ae2309ff8', '110', 'cstore', 'G276526701', '30000.00', '2025-06-08 17:13:27', '2025-06-09 17:13:27', '2025-06-08 17:16:17', 'settlement', '2765727882031861', NULL, NULL, 'alfamart', '2025-06-08 03:16:22', '2025-06-08 03:16:27'),
(51, 119, '7cbce054-0ab3-41f4-8dbd-b25594c4e2d9', '119', 'gopay', 'G276526701', '2000.00', '2025-06-08 17:41:48', '2025-06-08 17:56:48', NULL, 'pending', NULL, 'https://api.sandbox.midtrans.com/v2/gopay/7cbce054-0ab3-41f4-8dbd-b25594c4e2d9/qr-code', NULL, NULL, '2025-06-08 03:41:48', '2025-06-08 03:41:48');

-- --------------------------------------------------------

--
-- Struktur dari tabel `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(15, 'App\\Models\\User', 3, 'auth-token', '9ee2c424dc1608d9fe61fe87e147b20f5841b54bdd6de4ea2043ceba5c881965', '[\"*\"]', '2025-06-08 03:41:47', NULL, '2025-06-08 03:40:21', '2025-06-08 03:41:47');

-- --------------------------------------------------------

--
-- Struktur dari tabel `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('o9TrolnuCeVU0A8JqQj06FkwtttqZXfPgJ4j94um', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiYzJCYWptNnZUZmx1OEFZOEIwOWFWejU4ODNHcnBwTHpTendwTjhWOSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9iZWxpL3RhbWJhaC83Ijt9czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6Mzt9', 1749379239);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(10) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Kwanzza', 'arsal@gmail.com', NULL, '$2y$12$yasNjgmGfjZ.aQU4BW3qcO/zT2G76FOjvcBACJiccZ32PMHhT9GRW', NULL, '2025-06-02 04:54:26', '2025-06-02 04:54:26'),
(2, 'Sasa', 'sasa@gmail.com', NULL, '$2y$12$f52DTefh2VhXU0TVA4e7F.w8vLS8Emv/As4lNguSTywm9jZQDCdo.', NULL, '2025-06-02 06:22:44', '2025-06-02 06:22:44'),
(3, 'Arsal Fahrulloh', 'kwanzaa@gmail.com', NULL, '$2y$12$h6OBk..JfTomw5vNHsvsku6c9sVCVvHI0sBFV7EuKu0ST93rb08zq', NULL, '2025-06-02 06:33:00', '2025-06-02 06:33:00');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `beli`
--
ALTER TABLE `beli`
  ADD PRIMARY KEY (`id`),
  ADD KEY `beli_id_user_foreign` (`id_user`),
  ADD KEY `beli_id_barang_foreign` (`id_barang`),
  ADD KEY `beli_ibfk_1` (`id_payment`);

--
-- Indeks untuk tabel `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indeks untuk tabel `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indeks untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indeks untuk tabel `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indeks untuk tabel `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indeks untuk tabel `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payment_id_beli_foreign` (`id_beli`);

--
-- Indeks untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indeks untuk tabel `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `barang`
--
ALTER TABLE `barang`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `beli`
--
ALTER TABLE `beli`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;

--
-- AUTO_INCREMENT untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `payment`
--
ALTER TABLE `payment`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `beli`
--
ALTER TABLE `beli`
  ADD CONSTRAINT `beli_ibfk_1` FOREIGN KEY (`id_payment`) REFERENCES `payment` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `beli_id_barang_foreign` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `beli_id_user_foreign` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_id_beli_foreign` FOREIGN KEY (`id_beli`) REFERENCES `beli` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
