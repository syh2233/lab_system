package com.lab.system.repository;

import com.lab.system.entity.Device;
import com.lab.system.entity.Laboratory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DeviceRepository extends JpaRepository<Device, Long> {
    List<Device> findByLab(Laboratory laboratory);
    
    List<Device> findByNameContaining(String name);
    
    List<Device> findByStatus(String status);
} 