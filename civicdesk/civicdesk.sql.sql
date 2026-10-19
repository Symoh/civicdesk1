-- ============================================================
-- CivicDesk Database Schema
-- Target: MySQL 5.7+ / MariaDB 10.3+
-- Charset: utf8mb4
-- Import:  mysql -u root -p < civicdesk.sql
-- ============================================================

DROP DATABASE IF EXISTS civicdesk_db;
CREATE DATABASE civicdesk_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE civicdesk_db;

-- ------------------------------------------------------------
-- Table: users
-- Citizens and administrators.
-- ------------------------------------------------------------
CREATE TABLE users (
    id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
    full_name       VARCHAR(150) NOT NULL,
    email           VARCHAR(190) NOT NULL,
    phone           VARCHAR(30)  DEFAULT NULL,
    password_hash   VARCHAR(255) NOT NULL,
    role            ENUM('citizen', 'admin') NOT NULL DEFAULT 'citizen',
    is_active       TINYINT(1) NOT NULL DEFAULT 1,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                    ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_email (email),
    KEY idx_users_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Table: service_requests
-- Citizen-submitted service reports.
-- ------------------------------------------------------------
CREATE TABLE service_requests (
    id                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    reference_number   VARCHAR(30) NOT NULL,
    citizen_id         INT UNSIGNED NOT NULL,
    category           VARCHAR(80) NOT NULL,
    location           VARCHAR(255) NOT NULL,
    description        TEXT NOT NULL,
    image_path         VARCHAR(255) DEFAULT NULL,
    status             ENUM('Pending', 'In Progress', 'Resolved')
                       NOT NULL DEFAULT 'Pending',
    admin_notes        TEXT DEFAULT NULL,
    created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                       ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_requests_reference (reference_number),
    KEY idx_requests_citizen (citizen_id),
    KEY idx_requests_status (status),
    KEY idx_requests_created (created_at),
    CONSTRAINT fk_requests_citizen
        FOREIGN KEY (citizen_id) REFERENCES users (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Table: request_status_history
-- Audit log of every admin status change.
-- ------------------------------------------------------------
CREATE TABLE request_status_history (
    id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    request_id  INT UNSIGNED NOT NULL,
    changed_by  INT UNSIGNED NOT NULL,
    old_status  ENUM('Pending', 'In Progress', 'Resolved') NOT NULL,
    new_status  ENUM('Pending', 'In Progress', 'Resolved') NOT NULL,
    notes       TEXT DEFAULT NULL,
    changed_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_history_request (request_id),
    KEY idx_history_changed_by (changed_by),
    CONSTRAINT fk_history_request
        FOREIGN KEY (request_id) REFERENCES service_requests (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_history_user
        FOREIGN KEY (changed_by) REFERENCES users (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Seed: default administrator
-- Email:    admin@civicdesk.local
-- Password: Admin@123          
-- (Hash = password_hash('Admin@123', PASSWORD_DEFAULT))
-- ------------------------------------------------------------
INSERT INTO users (full_name, email, phone, password_hash, role)
VALUES (
    'System Administrator',
    'admin@civicdesk.local',
    '+254700000000',
    '$2y$10$e0MYzXyjpJS7Pd0RVvHwHe1HlCS4bZJ18JuywdFJ7wJzXqE9Wz5Hi',
    'admin'
);

-- ------------------------------------------------------------
-- CREATE USER 'civicdesk'@'localhost' IDENTIFIED BY 'change-this-strong-password';
-- GRANT SELECT, INSERT, UPDATE, DELETE
--   ON civicdesk_db.*
--   TO 'civicdesk'@'localhost';
-- FLUSH PRIVILEGES;

-- ============================================================
-- End of schema
-- ============================================================