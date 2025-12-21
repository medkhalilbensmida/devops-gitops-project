package com.example.devopsapi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.HashMap;
import java.util.Map;

@SpringBootApplication
@RestController
public class DevopsApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(DevopsApiApplication.class, args);
	}

	@GetMapping("/api/status")
	public Map<String, String> getStatus() {
		Map<String, String> status = new HashMap<>();
		status.put("status", "UP");
		status.put("message", "Backend API is online");
		status.put("version", "v1");
		return status;
	}

	@GetMapping("/api/dashboard")
	public Map<String, Object> getDashboardData() {
		Map<String, Object> data = new HashMap<>();
		data.put("uptime", "4h 12m");
		data.put("cpuUsage", "12%");
		data.put("memoryUsage", "512MB");
		data.put("activeUsers", 15);

		Map<String, String> health = new HashMap<>();
		health.put("database", "Connected");
		health.put("redis", "Healthy");
		health.put("storage", "92% free");
		data.put("systemHealth", health);

		return data;
	}
}
