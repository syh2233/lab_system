package com.lab.system.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalTime;

@Entity
@Table(name = "booking_rules")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookingRule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String description;

    private LocalTime openTime;

    private LocalTime closeTime;

    private Integer maxBookingDays;

    private Integer maxBookingHours;

    private Boolean requiresApproval;

    @ManyToOne
    @JoinColumn(name = "lab_id")
    private Laboratory lab;
} 