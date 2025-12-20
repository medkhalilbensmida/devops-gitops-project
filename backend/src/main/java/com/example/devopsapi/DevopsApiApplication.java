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
		status.put("message", "Backend is running and healthy");
		status.put("version", "v1");
		return status;
	}
}
