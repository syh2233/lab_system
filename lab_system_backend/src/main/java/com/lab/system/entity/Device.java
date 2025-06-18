package com.lab.system.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "devices")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Device {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String model;

    private String serialNumber;

    private String status;

    private LocalDateTime purchaseDate;

    private LocalDateTime lastMaintenanceDate;

    @ManyToOne
    @JoinColumn(name = "lab_id")
    private Laboratory lab;
} 