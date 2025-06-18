package com.lab.system.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class JwtResponse {
    private String token;
    private String type = "Bearer";
    private Long id;
    private String username;
    private String role;
    private List<String> permissions;

    public JwtResponse(String token, Long id, String username, String role, List<String> permissions) {
        this.token = token;
        this.id = id;
        this.username = username;
        this.role = role;
        this.permissions = permissions;
    }
} 