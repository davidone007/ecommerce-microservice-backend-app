package com.selimhorri.app.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.selimhorri.app.domain.OrderItem;
import com.selimhorri.app.domain.OrderItemId;

public interface OrderItemRepository extends JpaRepository<OrderItem, OrderItemId> {
    List<OrderItem> findByIsActiveTrue();
    Optional<OrderItem> findByOrderIdAndProductIdAndIsActiveTrue(Integer orderId, Integer productId);

}
