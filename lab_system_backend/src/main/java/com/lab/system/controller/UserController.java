package com.lab.system.controller;

import com.lab.system.dto.MessageResponse;
import com.lab.system.entity.User;
import com.lab.system.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userRepository.findAll();
        // 清除敏感信息
        users.forEach(user -> user.setPassword(null));
        return ResponseEntity.ok(users);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or @userSecurity.isCurrentUser(#id)")
    public ResponseEntity<?> getUserById(@PathVariable Long id) {
        Optional<User> user = userRepository.findById(id);
        if (user.isPresent()) {
            user.get().setPassword(null);  // 清除密码信息
            return ResponseEntity.ok(user.get());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("用户不存在", false));
        }
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> createUser(@RequestBody User user) {
        if (userRepository.existsByUsername(user.getUsername())) {
            return ResponseEntity.badRequest()
                    .body(new MessageResponse("用户名已存在", false));
        }

        // 加密密码
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        
        // 设置默认状态
        if (user.getStatus() == null) {
            user.setStatus(User.UserStatus.ACTIVE);
        }

        try {
            User savedUser = userRepository.save(user);
            savedUser.setPassword(null);  // 清除密码信息
            return ResponseEntity.status(HttpStatus.CREATED).body(savedUser);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new MessageResponse("创建用户失败: " + e.getMessage(), false));
        }
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or @userSecurity.isCurrentUser(#id)")
    public ResponseEntity<?> updateUser(@PathVariable Long id, @RequestBody User userDetails) {
        Optional<User> userData = userRepository.findById(id);

        if (userData.isPresent()) {
            User user = userData.get();
            
            // 只有管理员可以更改角色和状态
            if (userDetails.getRole() != null && userDetails.getRole() != user.getRole()) {
                user.setRole(userDetails.getRole());
            }
            
            if (userDetails.getStatus() != null && userDetails.getStatus() != user.getStatus()) {
                user.setStatus(userDetails.getStatus());
            }
            
            // 常规字段更新
            if (userDetails.getFullName() != null) {
                user.setFullName(userDetails.getFullName());
            }
            
            if (userDetails.getEmail() != null) {
                user.setEmail(userDetails.getEmail());
            }
            
            if (userDetails.getPhone() != null) {
                user.setPhone(userDetails.getPhone());
            }
            
            // 如果提供了新密码则更新
            if (userDetails.getPassword() != null && !userDetails.getPassword().isEmpty()) {
                user.setPassword(passwordEncoder.encode(userDetails.getPassword()));
            }
            
            User updatedUser = userRepository.save(user);
            updatedUser.setPassword(null);  // 清除密码信息
            return ResponseEntity.ok(updatedUser);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("用户不存在", false));
        }
    }

    @PutMapping("/{id}/change-password")
    @PreAuthorize("hasRole('ADMIN') or @userSecurity.isCurrentUser(#id)")
    public ResponseEntity<?> changePassword(@PathVariable Long id, 
                                     @RequestParam String oldPassword, 
                                     @RequestParam String newPassword) {
        Optional<User> userData = userRepository.findById(id);

        if (userData.isPresent()) {
            User user = userData.get();
            
            // 验证旧密码
            if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
                return ResponseEntity.badRequest()
                        .body(new MessageResponse("旧密码不正确", false));
            }
            
            // 更新密码
            user.setPassword(passwordEncoder.encode(newPassword));
            userRepository.save(user);
            
            return ResponseEntity.ok(new MessageResponse("密码已成功更新", true));
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("用户不存在", false));
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        try {
            if (!userRepository.existsById(id)) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new MessageResponse("用户不存在", false));
            }
            
            userRepository.deleteById(id);
            return ResponseEntity.ok(new MessageResponse("用户删除成功", true));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new MessageResponse("删除用户失败: " + e.getMessage(), false));
        }
    }
} 