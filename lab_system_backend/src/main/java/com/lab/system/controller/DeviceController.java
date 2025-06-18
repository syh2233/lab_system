package com.lab.system.controller;

import com.lab.system.dto.MessageResponse;
import com.lab.system.entity.Device;
import com.lab.system.entity.Laboratory;
import com.lab.system.repository.DeviceRepository;
import com.lab.system.repository.LaboratoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/devices")
public class DeviceController {
    @Autowired
    private DeviceRepository deviceRepository;

    @Autowired
    private LaboratoryRepository laboratoryRepository;

    @GetMapping
    public ResponseEntity<List<Device>> getAllDevices() {
        List<Device> devices = deviceRepository.findAll();
        return ResponseEntity.ok(devices);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getDeviceById(@PathVariable Long id) {
        Optional<Device> device = deviceRepository.findById(id);
        if (device.isPresent()) {
            return ResponseEntity.ok(device.get());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("设备不存在", false));
        }
    }

    @GetMapping("/lab/{labId}")
    public ResponseEntity<List<Device>> getDevicesByLab(@PathVariable Long labId) {
        Optional<Laboratory> lab = laboratoryRepository.findById(labId);
        if (lab.isPresent()) {
            List<Device> devices = deviceRepository.findByLab(lab.get());
            return ResponseEntity.ok(devices);
        } else {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> createDevice(@RequestBody Device device) {
        try {
            // 验证实验室是否存在
            if (device.getLab() != null && device.getLab().getId() != null) {
                Optional<Laboratory> lab = laboratoryRepository.findById(device.getLab().getId());
                if (!lab.isPresent()) {
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                            .body(new MessageResponse("指定的实验室不存在", false));
                }
            }
            
            Device savedDevice = deviceRepository.save(device);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedDevice);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new MessageResponse("创建失败: " + e.getMessage(), false));
        }
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> updateDevice(@PathVariable Long id, @RequestBody Device deviceDetails) {
        Optional<Device> deviceData = deviceRepository.findById(id);

        if (deviceData.isPresent()) {
            Device device = deviceData.get();
            device.setName(deviceDetails.getName());
            device.setModel(deviceDetails.getModel());
            device.setSerialNumber(deviceDetails.getSerialNumber());
            device.setStatus(deviceDetails.getStatus());
            
            if (deviceDetails.getPurchaseDate() != null) {
                device.setPurchaseDate(deviceDetails.getPurchaseDate());
            }
            
            if (deviceDetails.getLastMaintenanceDate() != null) {
                device.setLastMaintenanceDate(deviceDetails.getLastMaintenanceDate());
            }
            
            // 如果有新的实验室分配，需要验证
            if (deviceDetails.getLab() != null && deviceDetails.getLab().getId() != null) {
                Optional<Laboratory> lab = laboratoryRepository.findById(deviceDetails.getLab().getId());
                if (lab.isPresent()) {
                    device.setLab(lab.get());
                } else {
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                            .body(new MessageResponse("指定的实验室不存在", false));
                }
            }
            
            return ResponseEntity.ok(deviceRepository.save(device));
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("设备不存在", false));
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteDevice(@PathVariable Long id) {
        try {
            deviceRepository.deleteById(id);
            return ResponseEntity.ok(new MessageResponse("设备删除成功", true));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new MessageResponse("删除失败: " + e.getMessage(), false));
        }
    }
} 