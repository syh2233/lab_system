package com.lab.system.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "laboratories")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Laboratory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String location;

    private String description;
    
    private Integer capacity;

    @OneToMany(mappedBy = "lab")
    private Set<Device> devices = new HashSet<>();

    @ManyToOne
    @JoinColumn(name = "manager_id")
    private User manager;

    @OneToMany(mappedBy = "lab", cascade = CascadeType.ALL)
    private Set<Reservation> reservations = new HashSet<>();

    @OneToMany(mappedBy = "lab", cascade = CascadeType.ALL)
    private Set<Favorite> favorites = new HashSet<>();
} 