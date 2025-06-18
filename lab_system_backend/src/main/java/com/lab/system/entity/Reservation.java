package com.lab.system.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "reservations")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Reservation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "lab_id", nullable = false)
    private Laboratory lab;

    private LocalDate date;

    private LocalTime startTime;

    private LocalTime endTime;

    private String purpose;

    private LocalDate requestDate;

    @Enumerated(EnumType.STRING)
    private ReservationStatus status;

    private String rejectReason;

    public enum ReservationStatus {
        PENDING, APPROVED, REJECTED, CANCELED
    }
} 