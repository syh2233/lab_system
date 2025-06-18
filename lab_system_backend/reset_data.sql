-- 删除旧表（如果存在）
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS favorites;
DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS booking_rules;
DROP TABLE IF EXISTS devices;
DROP TABLE IF EXISTS laboratories;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- 创建表
-- 用户表
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL
);

-- 实验室表
CREATE TABLE laboratories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    description TEXT,
    capacity INT,
    manager_id BIGINT,
    FOREIGN KEY (manager_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 设备表
CREATE TABLE devices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    model VARCHAR(100),
    serial_number VARCHAR(100),
    status VARCHAR(50),
    purchase_date DATE,
    last_maintenance_date DATE,
    lab_id BIGINT,
    FOREIGN KEY (lab_id) REFERENCES laboratories(id) ON DELETE SET NULL
);

-- 预约表
CREATE TABLE reservations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    lab_id BIGINT NOT NULL,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    purpose TEXT,
    request_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    reject_reason TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lab_id) REFERENCES laboratories(id) ON DELETE CASCADE
);

-- 收藏表
CREATE TABLE favorites (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    lab_id BIGINT NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lab_id) REFERENCES laboratories(id) ON DELETE CASCADE,
    UNIQUE KEY user_lab_unique (user_id, lab_id)
);

-- 预约规则表
CREATE TABLE booking_rules (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    open_time TIME,
    close_time TIME,
    max_booking_days INT,
    max_booking_hours INT,
    requires_approval BOOLEAN DEFAULT TRUE,
    lab_id BIGINT,
    FOREIGN KEY (lab_id) REFERENCES laboratories(id) ON DELETE CASCADE
); 