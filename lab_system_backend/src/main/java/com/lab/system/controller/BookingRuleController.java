package com.lab.system.controller;

import com.lab.system.dto.MessageResponse;
import com.lab.system.entity.BookingRule;
import com.lab.system.entity.Laboratory;
import com.lab.system.repository.BookingRuleRepository;
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
@RequestMapping("/api/booking-rules")
public class BookingRuleController {
    @Autowired
    private BookingRuleRepository bookingRuleRepository;

    @Autowired
    private LaboratoryRepository laboratoryRepository;

    @GetMapping
    public ResponseEntity<List<BookingRule>> getAllBookingRules() {
        List<BookingRule> rules = bookingRuleRepository.findAll();
        return ResponseEntity.ok(rules);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getBookingRuleById(@PathVariable Long id) {
        Optional<BookingRule> rule = bookingRuleRepository.findById(id);
        if (rule.isPresent()) {
            return ResponseEntity.ok(rule.get());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("预约规则不存在", false));
        }
    }

    @GetMapping("/lab/{labId}")
    public ResponseEntity<List<BookingRule>> getBookingRulesByLab(@PathVariable Long labId) {
        Optional<Laboratory> lab = laboratoryRepository.findById(labId);
        if (lab.isPresent()) {
            List<BookingRule> rules = bookingRuleRepository.findByLab(lab.get());
            return ResponseEntity.ok(rules);
        } else {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> createBookingRule(@RequestBody BookingRule rule) {
        try {
            // 验证实验室是否存在
            if (rule.getLab() != null && rule.getLab().getId() != null) {
                Optional<Laboratory> lab = laboratoryRepository.findById(rule.getLab().getId());
                if (!lab.isPresent()) {
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                            .body(new MessageResponse("指定的实验室不存在", false));
                }
            }
            
            BookingRule savedRule = bookingRuleRepository.save(rule);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedRule);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new MessageResponse("创建失败: " + e.getMessage(), false));
        }
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> updateBookingRule(@PathVariable Long id, @RequestBody BookingRule ruleDetails) {
        Optional<BookingRule> ruleData = bookingRuleRepository.findById(id);

        if (ruleData.isPresent()) {
            BookingRule rule = ruleData.get();
            rule.setName(ruleDetails.getName());
            rule.setDescription(ruleDetails.getDescription());
            
            if (ruleDetails.getOpenTime() != null) {
                rule.setOpenTime(ruleDetails.getOpenTime());
            }
            
            if (ruleDetails.getCloseTime() != null) {
                rule.setCloseTime(ruleDetails.getCloseTime());
            }
            
            if (ruleDetails.getMaxBookingDays() != null) {
                rule.setMaxBookingDays(ruleDetails.getMaxBookingDays());
            }
            
            if (ruleDetails.getMaxBookingHours() != null) {
                rule.setMaxBookingHours(ruleDetails.getMaxBookingHours());
            }
            
            if (ruleDetails.getRequiresApproval() != null) {
                rule.setRequiresApproval(ruleDetails.getRequiresApproval());
            }
            
            // 如果有新的实验室分配，需要验证
            if (ruleDetails.getLab() != null && ruleDetails.getLab().getId() != null) {
                Optional<Laboratory> lab = laboratoryRepository.findById(ruleDetails.getLab().getId());
                if (lab.isPresent()) {
                    rule.setLab(lab.get());
                } else {
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                            .body(new MessageResponse("指定的实验室不存在", false));
                }
            }
            
            return ResponseEntity.ok(bookingRuleRepository.save(rule));
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("预约规则不存在", false));
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteBookingRule(@PathVariable Long id) {
        try {
            bookingRuleRepository.deleteById(id);
            return ResponseEntity.ok(new MessageResponse("预约规则删除成功", true));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new MessageResponse("删除失败: " + e.getMessage(), false));
        }
    }
} 