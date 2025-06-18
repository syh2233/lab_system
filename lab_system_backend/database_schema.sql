-- 创建数据库
CREATE DATABASE IF NOT EXISTS lab;
USE lab;

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
    purchase_date DATETIME,
    last_maintenance_date DATETIME,
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

-- 插入默认管理员账号
-- 密码为 admin123 的BCrypt加密结果
INSERT INTO users (username, password, full_name, role, status) 
VALUES ('admin', '$2a$10$yfB0FUKuJHMWK0bG9bQ4ieCE2mVJ3DZPnustOplrj1ByrdNVK/nA2', 'Admin User', 'ADMIN', 'ACTIVE');

-- 插入测试用普通用户账号
-- 密码为 123456 的BCrypt加密结果
INSERT INTO users (username, password, full_name, role, status) 
VALUES ('lisi', '$2a$10$qia/nJ1T5bYs4A.pLDGmWOlMG5LPiG8ldqMce8ddl7/jMF9SRZtMO', '李四', 'STUDENT', 'ACTIVE');

-- 插入测试实验室数据
INSERT INTO laboratories (name, location, description, capacity) VALUES 
('物理实验室', '1号楼201室', '装备齐全，支持物理实验教学与科研。', 30),
('化学实验室', '2号楼301室', '配备现代化化学设备，注重安全管理。', 25),
('生物实验室', '3号楼102室', '适合基础和高级生物实验。', 20),
('地理实验室', '4号楼104室', '地理学及相关领域实验。', 35),
('计算机实验室', '5号楼201室', '高性能计算环境，适合编程及人工智能项目。', 40);

-- 预约规则
INSERT INTO booking_rules (name, description, open_time, close_time, max_booking_days, max_booking_hours, lab_id) VALUES 
('标准预约规则', '一般实验室预约规则', '08:00:00', '20:00:00', 30, 4, 1),
('延时预约规则', '允许延长实验时间的规则', '08:00:00', '22:00:00', 30, 6, 2);

-- 设备数据
INSERT INTO devices (name, model, serial_number, status, lab_id) VALUES 
('电子显微镜', 'XR-2000', 'SN20210001', '正常', 1),
('分光光度计', 'SC-500', 'SN20210002', '正常', 2),
('培养箱', 'BG-100', 'SN20210003', '维修中', 3),
('地形模拟器', 'GT-300', 'SN20210004', '正常', 4),
('高性能服务器', 'IBM-X3650', 'SN20210005', '正常', 5); 