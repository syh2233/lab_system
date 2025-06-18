package com.lab.system.repository;

import com.lab.system.entity.BookingRule;
import com.lab.system.entity.Laboratory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface BookingRuleRepository extends JpaRepository<BookingRule, Long> {
    List<BookingRule> findByLab(Laboratory laboratory);
    
    Optional<BookingRule> findByLabAndName(Laboratory laboratory, String name);
} 