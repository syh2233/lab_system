-- 使用数据库
USE lab;

-- 清空表中的数据（如果需要重置）
-- SET FOREIGN_KEY_CHECKS = 0;
-- TRUNCATE TABLE favorites;
-- TRUNCATE TABLE reservations;
-- TRUNCATE TABLE booking_rules;
-- TRUNCATE TABLE devices;
-- TRUNCATE TABLE laboratories;
-- TRUNCATE TABLE users;
-- SET FOREIGN_KEY_CHECKS = 1;

-- 插入用户数据
-- 注意: 密码都是经过BCrypt加密的，实际明文如下
-- admin: admin123
-- lisi: 123456
-- wangwu: 123456
-- zhangsan: 123456
-- teacher1: 123456
INSERT INTO users (username, password, full_name, email, phone, role, status) VALUES 
('admin', '$2a$10$yfB0FUKuJHMWK0bG9bQ4ieCE2mVJ3DZPnustOplrj1ByrdNVK/nA2', '系统管理员', 'admin@lab.com', '13800138001', 'ADMIN', 'ACTIVE'),
('lisi', '$2a$10$qia/nJ1T5bYs4A.pLDGmWOlMG5LPiG8ldqMce8ddl7/jMF9SRZtMO', '李四', 'lisi@student.edu.cn', '13800138002', 'STUDENT', 'ACTIVE'),
('wangwu', '$2a$10$qia/nJ1T5bYs4A.pLDGmWOlMG5LPiG8ldqMce8ddl7/jMF9SRZtMO', '王五', 'wangwu@student.edu.cn', '13800138003', 'STUDENT', 'ACTIVE'),
('zhangsan', '$2a$10$qia/nJ1T5bYs4A.pLDGmWOlMG5LPiG8ldqMce8ddl7/jMF9SRZtMO', '张三', 'zhangsan@student.edu.cn', '13800138004', 'STUDENT', 'ACTIVE'),
('teacher1', '$2a$10$qia/nJ1T5bYs4A.pLDGmWOlMG5LPiG8ldqMce8ddl7/jMF9SRZtMO', '陈教授', 'teacher1@faculty.edu.cn', '13900139001', 'TEACHER', 'ACTIVE'),
('teacher2', '$2a$10$qia/nJ1T5bYs4A.pLDGmWOlMG5LPiG8ldqMce8ddl7/jMF9SRZtMO', '刘教授', 'teacher2@faculty.edu.cn', '13900139002', 'TEACHER', 'ACTIVE');

-- 插入实验室数据
INSERT INTO laboratories (name, location, description, capacity, manager_id) VALUES 
('物理实验室A', '理科楼1号楼201室', '装备齐全，支持物理实验教学与科研，配备高精度测量仪器。适合进行力学、热学、光学、电磁学等实验。', 30, (SELECT id FROM users WHERE username = 'teacher1')),
('物理实验室B', '理科楼1号楼202室', '专注于光学实验，配备激光装置、光学台、分光镜等设备。', 20, (SELECT id FROM users WHERE username = 'teacher1')),
('化学实验室A', '理科楼2号楼301室', '配备现代化化学设备，注重安全管理。适合进行一般化学实验和分析化学实验。', 25, (SELECT id FROM users WHERE username = 'teacher2')),
('化学实验室B', '理科楼2号楼302室', '专注于有机化学实验，配备分离提纯设备、反应釜等。', 20, (SELECT id FROM users WHERE username = 'teacher2')),
('生物实验室', '理科楼3号楼102室', '适合基础和高级生物实验。配备显微镜、培养箱、离心机等设备。', 20, (SELECT id FROM users WHERE username = 'teacher1')),
('地理实验室', '理科楼4号楼104室', '地理学及相关领域实验。配备地形模型、地质样本、气象观测设备等。', 35, (SELECT id FROM users WHERE username = 'teacher2')),
('计算机实验室A', '信息楼5号楼201室', '高性能计算环境，适合编程及人工智能项目。配备高性能服务器和工作站。', 40, (SELECT id FROM users WHERE username = 'admin')),
('计算机实验室B', '信息楼5号楼202室', '专注于网络技术实验，配备路由器、交换机等网络设备。', 30, (SELECT id FROM users WHERE username = 'admin'));

-- 插入设备数据
INSERT INTO devices (name, model, serial_number, status, purchase_date, last_maintenance_date, lab_id) VALUES 
('高精度电子显微镜', 'XR-2000', 'SN20210001', '正常', '2021-01-15', '2023-05-10', (SELECT id FROM laboratories WHERE name = '物理实验室A')),
('分光光度计', 'SC-500', 'SN20210002', '正常', '2021-02-20', '2023-04-15', (SELECT id FROM laboratories WHERE name = '化学实验室A')),
('培养箱', 'BG-100', 'SN20210003', '维修中', '2021-03-10', '2023-03-20', (SELECT id FROM laboratories WHERE name = '生物实验室')),
('地形模拟器', 'GT-300', 'SN20210004', '正常', '2021-04-05', '2023-06-05', (SELECT id FROM laboratories WHERE name = '地理实验室')),
('服务器集群', 'IBM-X3650', 'SN20210005', '正常', '2021-05-12', '2023-07-01', (SELECT id FROM laboratories WHERE name = '计算机实验室A')),
('激光干涉仪', 'LI-800', 'SN20210006', '正常', '2022-03-15', '2023-06-20', (SELECT id FROM laboratories WHERE name = '物理实验室B')),
('气相色谱仪', 'GC-2000', 'SN20210007', '正常', '2022-04-10', '2023-05-25', (SELECT id FROM laboratories WHERE name = '化学实验室B')),
('网络模拟系统', 'NET-SIM-500', 'SN20210008', '正常', '2022-05-20', '2023-07-10', (SELECT id FROM laboratories WHERE name = '计算机实验室B')),
('光学台', 'OPT-200', 'SN20210009', '维修中', '2021-06-15', '2023-04-05', (SELECT id FROM laboratories WHERE name = '物理实验室B')),
('高性能工作站', 'HP-Z8', 'SN20210010', '正常', '2022-07-01', '2023-06-15', (SELECT id FROM laboratories WHERE name = '计算机实验室A'));

-- 插入预约规则数据
INSERT INTO booking_rules (name, description, open_time, close_time, max_booking_days, max_booking_hours, requires_approval, lab_id) VALUES 
('物理实验室标准规则', '物理类实验室预约规则', '08:00:00', '20:00:00', 30, 4, true, (SELECT id FROM laboratories WHERE name = '物理实验室A')),
('物理实验室延时规则', '允许晚间使用的物理实验室规则', '08:00:00', '22:00:00', 30, 6, true, (SELECT id FROM laboratories WHERE name = '物理实验室B')),
('化学实验室标准规则', '化学类实验室预约规则，注重安全', '09:00:00', '19:00:00', 15, 3, true, (SELECT id FROM laboratories WHERE name = '化学实验室A')),
('化学实验室延时规则', '允许延长实验时间的化学实验室规则', '09:00:00', '21:00:00', 15, 5, true, (SELECT id FROM laboratories WHERE name = '化学实验室B')),
('生物实验室规则', '生物类实验室预约规则', '08:30:00', '20:30:00', 20, 4, true, (SELECT id FROM laboratories WHERE name = '生物实验室')),
('地理实验室规则', '地理类实验室预约规则', '08:00:00', '19:00:00', 15, 3, true, (SELECT id FROM laboratories WHERE name = '地理实验室')),
('计算机实验室规则', '计算机类实验室预约规则', '07:00:00', '23:00:00', 60, 8, true, (SELECT id FROM laboratories WHERE name = '计算机实验室A')),
('网络实验室规则', '网络实验室预约规则', '07:00:00', '23:00:00', 45, 6, true, (SELECT id FROM laboratories WHERE name = '计算机实验室B'));

-- 插入预约数据
INSERT INTO reservations (user_id, lab_id, date, start_time, end_time, purpose, request_date, status, reject_reason) VALUES 
((SELECT id FROM users WHERE username = 'lisi'), (SELECT id FROM laboratories WHERE name = '物理实验室A'), '2023-08-22', '14:00:00', '16:00:00', '力学实验课程练习', '2023-08-15', 'APPROVED', NULL),
((SELECT id FROM users WHERE username = 'lisi'), (SELECT id FROM laboratories WHERE name = '化学实验室A'), '2023-08-24', '09:00:00', '11:00:00', '化学分析实验', '2023-08-16', 'PENDING', NULL),
((SELECT id FROM users WHERE username = 'lisi'), (SELECT id FROM laboratories WHERE name = '生物实验室'), '2023-08-26', '13:00:00', '15:00:00', '细胞培养实验', '2023-08-17', 'REJECTED', '该时段已安排其他实验'),
((SELECT id FROM users WHERE username = 'wangwu'), (SELECT id FROM laboratories WHERE name = '计算机实验室A'), '2023-08-23', '10:00:00', '12:00:00', '人工智能课程项目', '2023-08-15', 'APPROVED', NULL),
((SELECT id FROM users WHERE username = 'wangwu'), (SELECT id FROM laboratories WHERE name = '地理实验室'), '2023-08-27', '14:00:00', '16:00:00', '地形分析实验', '2023-08-18', 'PENDING', NULL),
((SELECT id FROM users WHERE username = 'zhangsan'), (SELECT id FROM laboratories WHERE name = '物理实验室B'), '2023-08-22', '16:00:00', '18:00:00', '光学实验研究', '2023-08-14', 'APPROVED', NULL),
((SELECT id FROM users WHERE username = 'zhangsan'), (SELECT id FROM laboratories WHERE name = '计算机实验室B'), '2023-08-25', '09:00:00', '11:00:00', '网络安全实验', '2023-08-16', 'CANCELED', NULL),
((SELECT id FROM users WHERE username = 'teacher1'), (SELECT id FROM laboratories WHERE name = '物理实验室A'), '2023-08-28', '10:00:00', '14:00:00', '教师科研项目', '2023-08-20', 'APPROVED', NULL),
((SELECT id FROM users WHERE username = 'teacher2'), (SELECT id FROM laboratories WHERE name = '化学实验室B'), '2023-08-30', '13:00:00', '17:00:00', '有机化学实验教学准备', '2023-08-21', 'APPROVED', NULL);

-- 插入收藏数据
INSERT INTO favorites (user_id, lab_id, created_at) VALUES 
((SELECT id FROM users WHERE username = 'lisi'), (SELECT id FROM laboratories WHERE name = '物理实验室A'), '2023-08-10 10:15:00'),
((SELECT id FROM users WHERE username = 'lisi'), (SELECT id FROM laboratories WHERE name = '计算机实验室A'), '2023-08-12 14:30:00'),
((SELECT id FROM users WHERE username = 'wangwu'), (SELECT id FROM laboratories WHERE name = '计算机实验室A'), '2023-08-11 09:20:00'),
((SELECT id FROM users WHERE username = 'wangwu'), (SELECT id FROM laboratories WHERE name = '计算机实验室B'), '2023-08-13 16:45:00'),
((SELECT id FROM users WHERE username = 'zhangsan'), (SELECT id FROM laboratories WHERE name = '物理实验室B'), '2023-08-09 11:30:00'),
((SELECT id FROM users WHERE username = 'teacher1'), (SELECT id FROM laboratories WHERE name = '化学实验室A'), '2023-08-08 10:00:00'); 