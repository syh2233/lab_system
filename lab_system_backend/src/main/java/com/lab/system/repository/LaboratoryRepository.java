package com.lab.system.repository;

import com.lab.system.entity.Laboratory;
import com.lab.system.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LaboratoryRepository extends JpaRepository<Laboratory, Long> {
    List<Laboratory> findByNameContaining(String name);
    
    List<Laboratory> findByManager(User manager);
    
    List<Laboratory> findByLocationContaining(String location);
} 