# 实验室预约系统后端

这是实验室预约系统的后端服务，使用Spring Boot框架开发，提供了用户认证、实验室管理、预约管理等功能的RESTful API。

## 技术栈

- Java 11
- Spring Boot 2.7.0
- Spring Security + JWT认证
- Spring Data JPA
- MySQL 8.0

## 项目结构

```
lab_system_backend/
├── src/
│   ├── main/
│   │   ├── java/com/lab/system/
│   │   │   ├── controller/       # 控制器层
│   │   │   ├── dto/              # 数据传输对象
│   │   │   ├── entity/           # 实体类
│   │   │   ├── repository/       # 数据访问层
│   │   │   ├── security/         # 安全配置
│   │   │   └── LabSystemApplication.java  # 应用入口
│   │   └── resources/
│   │       └── application.properties  # 应用配置
│   └── test/                    # 测试代码
└── pom.xml                      # Maven配置
```

## API接口

### 认证接口

- `POST /api/auth/login`: 用户登录
- `GET /api/auth/check`: 检查认证状态

### 用户管理

- `GET /api/users`: 获取所有用户(管理员)
- `GET /api/users/{id}`: 获取单个用户
- `POST /api/users`: 创建用户(管理员)
- `PUT /api/users/{id}`: 更新用户
- `PUT /api/users/{id}/change-password`: 修改密码
- `DELETE /api/users/{id}`: 删除用户(管理员)

### 实验室管理

- `GET /api/laboratories`: 获取所有实验室
- `GET /api/laboratories/{id}`: 获取单个实验室
- `GET /api/laboratories/search`: 搜索实验室
- `POST /api/laboratories`: 创建实验室(管理员)
- `PUT /api/laboratories/{id}`: 更新实验室(管理员)
- `DELETE /api/laboratories/{id}`: 删除实验室(管理员)

### 设备管理

- `GET /api/devices`: 获取所有设备
- `GET /api/devices/{id}`: 获取单个设备
- `GET /api/devices/lab/{labId}`: 获取某实验室的设备
- `POST /api/devices`: 创建设备(管理员)
- `PUT /api/devices/{id}`: 更新设备(管理员)
- `DELETE /api/devices/{id}`: 删除设备(管理员)

### 预约管理

- `GET /api/reservations`: 获取所有预约(管理员)
- `GET /api/reservations/my`: 获取当前用户的预约
- `GET /api/reservations/{id}`: 获取单个预约
- `GET /api/reservations/lab/{labId}`: 获取某实验室的预约
- `GET /api/reservations/date`: 获取某日期的预约
- `POST /api/reservations`: 创建预约
- `PUT /api/reservations/{id}/status`: 更新预约状态(管理员)
- `DELETE /api/reservations/{id}`: 取消预约

### 收藏管理

- `GET /api/favorites/my`: 获取当前用户的收藏
- `POST /api/favorites/{labId}`: 添加收藏
- `DELETE /api/favorites/{labId}`: 移除收藏
- `GET /api/favorites/check/{labId}`: 检查是否已收藏

### 预约规则

- `GET /api/booking-rules`: 获取所有预约规则
- `GET /api/booking-rules/{id}`: 获取单个预约规则
- `GET /api/booking-rules/lab/{labId}`: 获取某实验室的预约规则
- `POST /api/booking-rules`: 创建预约规则(管理员)
- `PUT /api/booking-rules/{id}`: 更新预约规则(管理员)
- `DELETE /api/booking-rules/{id}`: 删除预约规则(管理员)

## 数据库初始化

系统启动时会自动创建表结构，但需要手动插入初始数据。可以使用以下SQL创建管理员账号：

```sql
INSERT INTO users (username, password, full_name, role, status) 
VALUES ('admin', '$2a$10$yfB0FUKuJHMWK0bG9bQ4ieCE2mVJ3DZPnustOplrj1ByrdNVK/nA2', 'Admin User', 'ADMIN', 'ACTIVE');
```

注：上述密码为"admin123"的BCrypt加密结果。

## 运行项目

1. 确保已安装JDK 11和Maven
2. 配置MySQL数据库，创建名为`lab_system`的数据库
3. 修改`application.properties`中的数据库连接信息
4. 执行以下命令启动项目：

```bash
mvn spring-boot:run
```

服务默认运行在8080端口，可通过`http://localhost:8080`访问API。 