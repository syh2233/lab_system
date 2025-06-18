package com.lab.system.repository;

import com.lab.system.entity.Favorite;
import com.lab.system.entity.Laboratory;
import com.lab.system.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    List<Favorite> findByUser(User user);
    
    List<Favorite> findByLab(Laboratory lab);
    
    Optional<Favorite> findByUserAndLab(User user, Laboratory lab);
    
    boolean existsByUserAndLab(User user, Laboratory lab);
    
    void deleteByUserAndLab(User user, Laboratory lab);
} 