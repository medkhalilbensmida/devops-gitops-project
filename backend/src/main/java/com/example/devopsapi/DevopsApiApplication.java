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

// --- ENTITIES ---

@Entity
class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String description;
    private double price;
    private String imageUrl;

    public Product() {
    }

    public Product(String name, String description, double price, String imageUrl) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
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

    @ElementCollection
    private List<String> productNames = new ArrayList<>();

    // Getters and Setters
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
}

// --- REPOSITORIES ---

@Repository
interface ProductRepository extends JpaRepository<Product, Long> {
}

@Repository
interface OrderRepository extends JpaRepository<UserOrder, Long> {
}

// --- CTRL ---

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
class EcommerceController {
    private final ProductRepository productRepo;
    private final OrderRepository orderRepo;

    public EcommerceController(ProductRepository productRepo, OrderRepository orderRepo) {
        this.productRepo = productRepo;
        this.orderRepo = orderRepo;

        // Seed some data
        if (productRepo.count() == 0) {
            productRepo.save(new Product("Cloud Server Pro", "High-performance virtual instance", 99.99,
                    "https://images.unsplash.com/photo-1558494949-ef010cbdcc4b?w=400"));
            productRepo.save(new Product("Kubernetes Masterclass", "Complete guide to K8s orchestration", 49.50,
                    "https://images.unsplash.com/photo-1667372333374-0d44583d7bc9?w=400"));
            productRepo.save(new Product("DevOps Monitoring Pack", "Prometheus & Grafana pre-built dashboards", 25.00,
                    "https://images.unsplash.com/photo-1551288049-bbbda5366391?w=400"));
        }
    }

    @GetMapping("/health")
    public Map<String, String> health() {
        return Map.of("status", "UP", "service", "E-commerce API");
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
}
