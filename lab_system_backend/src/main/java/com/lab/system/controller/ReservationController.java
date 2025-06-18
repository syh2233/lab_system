package com.lab.system.controller;

import com.lab.system.dto.MessageResponse;
import com.lab.system.entity.Laboratory;
import com.lab.system.entity.Reservation;
import com.lab.system.entity.User;
import com.lab.system.repository.LaboratoryRepository;
import com.lab.system.repository.ReservationRepository;
import com.lab.system.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/reservations")
public class ReservationController {
    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private LaboratoryRepository laboratoryRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<Reservation>> getAllReservations() {
        List<Reservation> reservations = reservationRepository.findAll();
        return ResponseEntity.ok(reservations);
    }
    
    @GetMapping("/my")
    public ResponseEntity<?> getMyReservations() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        
        Optional<User> user = userRepository.findByUsername(userDetails.getUsername());
        if (!user.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("用户不存在", false));
        }
        
        List<Reservation> reservations = reservationRepository.findByUser(user.get());
        return ResponseEntity.ok(reservations);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getReservationById(@PathVariable Long id) {
        Optional<Reservation> reservation = reservationRepository.findById(id);
        if (reservation.isPresent()) {
            return ResponseEntity.ok(reservation.get());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("预约记录不存在", false));
        }
    }
    
    @GetMapping("/lab/{labId}")
    public ResponseEntity<List<Reservation>> getReservationsByLab(@PathVariable Long labId) {
        Optional<Laboratory> lab = laboratoryRepository.findById(labId);
        if (lab.isPresent()) {
            List<Reservation> reservations = reservationRepository.findByLab(lab.get());
            return ResponseEntity.ok(reservations);
        } else {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @GetMapping("/date")
    public ResponseEntity<List<Reservation>> getReservationsByDate(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        List<Reservation> reservations = reservationRepository.findByDate(date);
        return ResponseEntity.ok(reservations);
    }

    @PostMapping
    public ResponseEntity<?> createReservation(@RequestBody Reservation reservation) {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            
            Optional<User> user = userRepository.findByUsername(userDetails.getUsername());
            if (!user.isPresent()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new MessageResponse("用户不存在", false));
            }
            
            reservation.setUser(user.get());
            reservation.setStatus(Reservation.ReservationStatus.PENDING);
            reservation.setRequestDate(LocalDate.now());
            
            // 检查实验室是否存在
            Optional<Laboratory> lab = laboratoryRepository.findById(reservation.getLab().getId());
            if (!lab.isPresent()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new MessageResponse("实验室不存在", false));
            }
            
            // 检查时间是否冲突
            List<Reservation> conflictingReservations = reservationRepository.findConflictingReservations(
                    lab.get(), reservation.getDate(), reservation.getStartTime(), reservation.getEndTime());
            if (!conflictingReservations.isEmpty()) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(new MessageResponse("所选时间段已被预约", false));
            }
            
            Reservation savedReservation = reservationRepository.save(reservation);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedReservation);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new MessageResponse("创建预约失败: " + e.getMessage(), false));
        }
    }

    @PutMapping("/{id}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> updateReservationStatus(@PathVariable Long id, 
                                              @RequestParam Reservation.ReservationStatus status,
                                              @RequestParam(required = false) String rejectReason) {
        Optional<Reservation> reservationData = reservationRepository.findById(id);

        if (reservationData.isPresent()) {
            Reservation reservation = reservationData.get();
            reservation.setStatus(status);
            
            if (status == Reservation.ReservationStatus.REJECTED && rejectReason != null) {
                reservation.setRejectReason(rejectReason);
            }
            
            return ResponseEntity.ok(reservationRepository.save(reservation));
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("预约记录不存在", false));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> cancelReservation(@PathVariable Long id) {
        Optional<Reservation> reservationData = reservationRepository.findById(id);

        if (reservationData.isPresent()) {
            Reservation reservation = reservationData.get();
            
            // 获取当前用户
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            Optional<User> user = userRepository.findByUsername(userDetails.getUsername());
            
            // 只有管理员或预约人自己才能取消
            if (user.isPresent() && (user.get().getRole() == User.UserRole.ADMIN 
                    || reservation.getUser().getId().equals(user.get().getId()))) {
                reservation.setStatus(Reservation.ReservationStatus.CANCELED);
                reservationRepository.save(reservation);
                return ResponseEntity.ok(new MessageResponse("预约已取消", true));
            } else {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new MessageResponse("无权限取消此预约", false));
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("预约记录不存在", false));
        }
    }
} 