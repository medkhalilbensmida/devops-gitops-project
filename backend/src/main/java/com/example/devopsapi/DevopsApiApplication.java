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

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import java.util.List;

@SpringBootApplication
public class DevopsApiApplication {
    public static void main(String[] args) {
        SpringApplication.run(DevopsApiApplication.class, args);
    }

    @Bean
    public OpenAPI customOpenAPI() {
        // Force les URLs relatives pour Swagger (fix pour le port-forwarding)
        return new OpenAPI().servers(List.of(new Server().url("/")));
    }
}

@Entity
class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nameKey; // Key for translation
    private String categoryKey; // Key for translation
    private String descKey; // Key for translation
    private double price;
    private String imageUrl;
    private int stock;

    public Product() {
    }

    public Product(String nameKey, String categoryKey, String descKey, double price, String imageUrl, int stock) {
        this.nameKey = nameKey;
        this.categoryKey = categoryKey;
        this.descKey = descKey;
        this.price = price;
        this.imageUrl = imageUrl;
        this.stock = stock;
    }

    public Long getId() {
        return id;
    }

    public String getNameKey() {
        return nameKey;
    }

    public String getCategoryKey() {
        return categoryKey;
    }

    public String getDescKey() {
        return descKey;
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
    private String status = "PENDING"; // Translatable

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

@Entity
class ContactMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String email;
    private String subject;
    private String message;
    private LocalDateTime sentAt = LocalDateTime.now();

    public ContactMessage() {
    }

    public ContactMessage(String name, String email, String subject, String message) {
        this.name = name;
        this.email = email;
        this.subject = subject;
        this.message = message;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getSubject() {
        return subject;
    }

    public String getMessage() {
        return message;
    }

    public LocalDateTime getSentAt() {
        return sentAt;
    }
}

@Repository
interface ProductRepository extends JpaRepository<Product, Long> {
}

@Repository
interface OrderRepository extends JpaRepository<UserOrder, Long> {
}

@Repository
interface ContactRepository extends JpaRepository<ContactMessage, Long> {
}

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
class EcommerceController {
    private final ProductRepository productRepo;
    private final OrderRepository orderRepo;
    private final ContactRepository contactRepo;

    public EcommerceController(ProductRepository productRepo, OrderRepository orderRepo,
            ContactRepository contactRepo) {
        this.productRepo = productRepo;
        this.orderRepo = orderRepo;
        this.contactRepo = contactRepo;

        if (productRepo.count() == 0) {
            // Seeding with translation keys for total internationalization
            productRepo.save(new Product("prod_laptop_hp", "cat_laptops", "desc_laptop_hp", 1899.99,
                    "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=800", 12));
            productRepo.save(new Product("prod_laptop_mbp", "cat_laptops", "desc_laptop_mbp", 2499.00,
                    "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=800", 8));
            productRepo.save(new Product("prod_laptop_razer", "cat_laptops", "desc_laptop_razer", 2999.00,
                    "https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?q=80&w=800", 5));
            productRepo.save(new Product("prod_mon_5k", "cat_monitors", "desc_mon_5k", 1249.00,
                    "https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=800", 7));
            productRepo.save(new Product("prod_mon_g9", "cat_monitors", "desc_mon_g9", 1499.00,
                    "https://images.unsplash.com/photo-1616763355548-1b606f439f86?q=80&w=800", 3));
            productRepo.save(new Product("prod_kb_mx", "cat_accessories", "desc_kb_mx", 179.50,
                    "https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?q=80&w=800", 30));
            productRepo.save(new Product("prod_mouse_mx", "cat_accessories", "desc_mouse_mx", 99.00,
                    "https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?q=80&w=800", 50));
            productRepo.save(new Product("prod_audio_studio", "cat_audio", "desc_audio_studio", 349.00,
                    "https://images.unsplash.com/photo-1546435770-a3e426bf472b?q=80&w=800", 15));
            productRepo.save(new Product("prod_audio_pods", "cat_audio", "desc_audio_pods", 549.00,
                    "https://images.unsplash.com/photo-1613040809024-b4ef7ba99bc3?q=80&w=800", 10));
            productRepo.save(new Product("prod_gadget_drone", "cat_gadgets", "desc_gadget_drone", 899.00,
                    "https://images.unsplash.com/photo-1473968512445-3b7c53f27b61?q=80&w=800", 5));
            productRepo.save(new Product("prod_gadget_deck", "cat_gadgets", "desc_gadget_deck", 649.00,
                    "https://images.unsplash.com/photo-1621259182978-f09e5ce6793e?q=80&w=800", 12));
            productRepo.save(new Product("prod_office_desk", "cat_office", "desc_office_desk", 599.00,
                    "https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?q=80&w=800", 20));
        }
    }

    @GetMapping("/health")
    public Map<String, String> health() {
        return Map.of("status", "UP", "service", "Tech Hub Full-Stack API");
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

    @PostMapping("/contact")
    public ContactMessage sendContactMessage(@RequestBody ContactMessage msg) {
        return contactRepo.save(msg);
    }
}
