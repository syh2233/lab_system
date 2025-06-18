package com.lab.system.security;

import com.lab.system.entity.User;
import com.lab.system.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component("userSecurity")
public class UserSecurity {
    @Autowired
    private UserRepository userRepository;

    public boolean isCurrentUser(Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return false;
        }

        if (!(authentication.getPrincipal() instanceof UserDetails)) {
            return false;
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Optional<User> user = userRepository.findByUsername(userDetails.getUsername());

        return user.isPresent() && user.get().getId().equals(id);
    }
} 