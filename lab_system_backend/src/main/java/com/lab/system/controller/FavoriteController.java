package com.lab.system.controller;

import com.lab.system.dto.MessageResponse;
import com.lab.system.entity.Favorite;
import com.lab.system.entity.Laboratory;
import com.lab.system.entity.User;
import com.lab.system.repository.FavoriteRepository;
import com.lab.system.repository.LaboratoryRepository;
import com.lab.system.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/favorites")
public class FavoriteController {
    @Autowired
    private FavoriteRepository favoriteRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private LaboratoryRepository laboratoryRepository;

    @GetMapping("/my")
    public ResponseEntity<?> getMyFavorites() {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new MessageResponse("未授权操作", false));
        }

        List<Favorite> favorites = favoriteRepository.findByUser(currentUser);
        return ResponseEntity.ok(favorites);
    }

    @PostMapping("/{labId}")
    public ResponseEntity<?> addFavorite(@PathVariable Long labId) {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new MessageResponse("未授权操作", false));
        }

        Optional<Laboratory> lab = laboratoryRepository.findById(labId);
        if (!lab.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("实验室不存在", false));
        }

        if (favoriteRepository.existsByUserAndLab(currentUser, lab.get())) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(new MessageResponse("已添加到收藏", true));
        }

        Favorite favorite = new Favorite();
        favorite.setUser(currentUser);
        favorite.setLab(lab.get());
        favorite.setCreatedAt(LocalDateTime.now());

        favoriteRepository.save(favorite);
        return ResponseEntity.ok(new MessageResponse("添加收藏成功", true));
    }

    @DeleteMapping("/{labId}")
    public ResponseEntity<?> removeFavorite(@PathVariable Long labId) {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new MessageResponse("未授权操作", false));
        }

        Optional<Laboratory> lab = laboratoryRepository.findById(labId);
        if (!lab.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("实验室不存在", false));
        }

        Optional<Favorite> favorite = favoriteRepository.findByUserAndLab(currentUser, lab.get());
        if (!favorite.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("收藏不存在", false));
        }

        favoriteRepository.delete(favorite.get());
        return ResponseEntity.ok(new MessageResponse("移除收藏成功", true));
    }

    @GetMapping("/check/{labId}")
    public ResponseEntity<?> checkFavorite(@PathVariable Long labId) {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new MessageResponse("未授权操作", false));
        }

        Optional<Laboratory> lab = laboratoryRepository.findById(labId);
        if (!lab.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("实验室不存在", false));
        }

        boolean isFavorite = favoriteRepository.existsByUserAndLab(currentUser, lab.get());
        return ResponseEntity.ok(new MessageResponse(String.valueOf(isFavorite), true));
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        return userRepository.findByUsername(userDetails.getUsername()).orElse(null);
    }
} 