package com.lab.system.controller;

import com.lab.system.dto.JwtResponse;
import com.lab.system.dto.LoginRequest;
import com.lab.system.dto.MessageResponse;
import com.lab.system.entity.User;
import com.lab.system.repository.UserRepository;
import com.lab.system.security.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtUtils jwtUtils;

    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        System.out.println("前端传来的用户名: [" + loginRequest.getUsername() + "]");
        System.out.println("前端传来的明文密码: [" + loginRequest.getPassword() + "] 长度: [" + loginRequest.getPassword().length() + "]");
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);
        
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        User user = userRepository.findByUsername(userDetails.getUsername()).orElseThrow();
        
        List<String> permissions = new ArrayList<>();
        // 这里可以根据角色添加更多的权限
        if (user.getRole() == User.UserRole.ADMIN) {
            permissions.add("MANAGE_LABS");
            permissions.add("MANAGE_USERS");
            permissions.add("APPROVE_RESERVATIONS");
        } else if (user.getRole() == User.UserRole.TEACHER) {
            permissions.add("MAKE_RESERVATIONS");
            permissions.add("VIEW_LABS");
        } else {
            permissions.add("MAKE_RESERVATIONS");
            permissions.add("VIEW_LABS");
        }
        
        return ResponseEntity.ok(new JwtResponse(
                jwt, 
                user.getId(),
                user.getUsername(),
                user.getRole().name(),
                permissions));
    }
    
    @GetMapping("/check")
    public ResponseEntity<?> checkAuthentication() {
        return ResponseEntity.ok(new MessageResponse("认证有效", true));
    }
} 