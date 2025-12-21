package com.example.devopsapi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.*;
import jakarta.persistence.*;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.time.LocalDateTime;

@SpringBootApplication
public class DevopsApiApplication {
    public static void main(String[] args) {
        SpringApplication.run(DevopsApiApplication.class, args);
    }
}

@Entity
class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String category;
    private String description;
    private double price;
    private String imageUrl;
    private int stock;

    public Product() {
    }

    public Product(String name, String category, String description, double price, String imageUrl, int stock) {
        this.name = name;
        this.category = category;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.stock = stock;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getCategory() {
        return category;
    }

    public String getDescription() {
        return description;
    }

    public double getPrice() {
        return price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public int getStock() {
        return stock;
    }
}

@Entity
class UserOrder {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String customerName;
    private String customerEmail;
    private double totalAmount;
    private LocalDateTime orderDate = LocalDateTime.now();
    private String status = "PENDING";

    @ElementCollection
    private List<String> productNames = new ArrayList<>();

    public Long getId() {
        return id;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public List<String> getProductNames() {
        return productNames;
    }

    public void setProductNames(List<String> productNames) {
        this.productNames = productNames;
    }

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

@Repository
interface ProductRepository extends JpaRepository<Product, Long> {
}

@Repository
interface OrderRepository extends JpaRepository<UserOrder, Long> {
}

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
class EcommerceController {
    private final ProductRepository productRepo;
    private final OrderRepository orderRepo;

    public EcommerceController(ProductRepository productRepo, OrderRepository orderRepo) {
        this.productRepo = productRepo;
        this.orderRepo = orderRepo;

        if (productRepo.count() == 0) {
            productRepo.save(new Product("EliteBook Pro X1", "Laptops", "High-performance laptop for developers",
                    1899.99, "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=800", 12));
            productRepo.save(new Product("UltraWide 5K Display", "Monitors", "Perfect color accuracy for creative work",
                    1249.00, "https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=800", 7));
            productRepo
                    .save(new Product("Mechanical MX Keyboard", "Accessories", "Tactile feedback with RGB backlighting",
                            179.50, "https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?q=80&w=800", 30));
            productRepo.save(new Product("Studio Noise-Canceling", "Audio", "Immersive sound with long-lasting battery",
                    349.00, "https://images.unsplash.com/photo-1546435770-a3e426bf472b?q=80&w=800", 15));
            productRepo.save(new Product("Stealth Camera Drone", "Gadgets", "4K HDR video with AI tracking", 899.00,
                    "https://images.unsplash.com/photo-1473968512445-3b7c53f27b61?q=80&w=800", 5));
            productRepo.save(new Product("ErgoDesk Pro Stand", "Office", "Adjustable standing desk with memory", 599.00,
                    "https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?q=80&w=800", 20));
        }
    }

    @GetMapping("/health")
    public Map<String, String> health() {
        return Map.of("status", "UP", "service", "Tech Hub API");
    }

    @GetMapping("/products")
    public List<Product> getProducts() {
        return productRepo.findAll();
    }

    @PostMapping("/orders")
    public UserOrder placeOrder(@RequestBody UserOrder order) {
        return orderRepo.save(order);
    }

    @GetMapping("/orders")
    public List<UserOrder> getOrders() {
        return orderRepo.findAll();
    }

    @PutMapping("/orders/{id}/status")
    public UserOrder updateOrderStatus(@PathVariable Long id, @RequestBody Map<String, String> body) {
        UserOrder order = orderRepo.findById(id).orElseThrow();
        order.setStatus(body.get("status"));
        return orderRepo.save(order);
    }
}
