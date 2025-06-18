package com.lab.system.repository;

import com.lab.system.entity.Laboratory;
import com.lab.system.entity.Reservation;
import com.lab.system.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    List<Reservation> findByUser(User user);
    
    List<Reservation> findByLab(Laboratory laboratory);
    
    List<Reservation> findByStatus(Reservation.ReservationStatus status);
    
    List<Reservation> findByUserAndStatus(User user, Reservation.ReservationStatus status);
    
    List<Reservation> findByDate(LocalDate date);
    
    List<Reservation> findByDateBetween(LocalDate startDate, LocalDate endDate);
    
    @Query("SELECT r FROM Reservation r WHERE r.lab = :lab AND r.date = :date " +
           "AND ((r.startTime <= :endTime AND r.endTime >= :startTime) " +
           "AND r.status = 'APPROVED')")
    List<Reservation> findConflictingReservations(
            @Param("lab") Laboratory lab,
            @Param("date") LocalDate date,
            @Param("startTime") LocalTime startTime,
            @Param("endTime") LocalTime endTime);
} 