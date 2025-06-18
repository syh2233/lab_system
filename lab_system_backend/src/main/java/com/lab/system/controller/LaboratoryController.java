package com.lab.system.controller;

import com.lab.system.dto.MessageResponse;
import com.lab.system.entity.Laboratory;
import com.lab.system.entity.User;
import com.lab.system.repository.LaboratoryRepository;
import com.lab.system.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/laboratories")
public class LaboratoryController {
    @Autowired
    private LaboratoryRepository laboratoryRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public ResponseEntity<List<Laboratory>> getAllLaboratories() {
        List<Laboratory> labs = laboratoryRepository.findAll();
        return ResponseEntity.ok(labs);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getLaboratoryById(@PathVariable Long id) {
        Optional<Laboratory> laboratory = laboratoryRepository.findById(id);
        if (laboratory.isPresent()) {
            return ResponseEntity.ok(laboratory.get());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("实验室不存在", false));
        }
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> createLaboratory(@RequestBody Laboratory laboratory) {
        try {
            Laboratory savedLab = laboratoryRepository.save(laboratory);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedLab);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new MessageResponse("创建失败: " + e.getMessage(), false));
        }
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> updateLaboratory(@PathVariable Long id, @RequestBody Laboratory laboratoryDetails) {
        Optional<Laboratory> laboratoryData = laboratoryRepository.findById(id);

        if (laboratoryData.isPresent()) {
            Laboratory laboratory = laboratoryData.get();
            laboratory.setName(laboratoryDetails.getName());
            laboratory.setLocation(laboratoryDetails.getLocation());
            laboratory.setDescription(laboratoryDetails.getDescription());
            laboratory.setCapacity(laboratoryDetails.getCapacity());
            
            // 如果有新的管理员，需要设置
            if (laboratoryDetails.getManager() != null && laboratoryDetails.getManager().getId() != null) {
                Optional<User> manager = userRepository.findById(laboratoryDetails.getManager().getId());
                manager.ifPresent(laboratory::setManager);
            }
            
            return ResponseEntity.ok(laboratoryRepository.save(laboratory));
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("实验室不存在", false));
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteLaboratory(@PathVariable Long id) {
        try {
            laboratoryRepository.deleteById(id);
            return ResponseEntity.ok(new MessageResponse("实验室删除成功", true));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new MessageResponse("删除失败: " + e.getMessage(), false));
        }
    }

    @GetMapping("/search")
    public ResponseEntity<List<Laboratory>> searchLaboratory(@RequestParam String name) {
        List<Laboratory> labs = laboratoryRepository.findByNameContaining(name);
        return ResponseEntity.ok(labs);
    }
} 