package com.lab.system.repository;

import com.lab.system.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    
    Boolean existsByUsername(String username);
    
    List<User> findByRole(User.UserRole role);
    
    List<User> findByStatus(User.UserStatus status);
} 