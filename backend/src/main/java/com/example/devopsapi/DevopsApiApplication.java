package com.example.devopsapi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.*;
import jakarta.persistence.*;
import java.util.List;
import java.util.Map;
import java.time.LocalDateTime;

@SpringBootApplication
public class DevopsApiApplication {
	public static void main(String[] args) {
		SpringApplication.run(DevopsApiApplication.class, args);
	}
}

@Entity
class DevOpsTask {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	private String title;
	private String description;
	private String status; // TODO, IN_PROGRESS, DONE
	private String priority; // LOW, MEDIUM, HIGH
	private LocalDateTime createdAt = LocalDateTime.now();

	// Getters and Setters
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPriority() {
		return priority;
	}

	public void setPriority(String priority) {
		this.priority = priority;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}
}

@Repository
interface TaskRepository extends JpaRepository<DevOpsTask, Long> {
}

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
class TaskController {
	private final TaskRepository repository;

	public TaskController(TaskRepository repository) {
		this.repository = repository;
	}

	@GetMapping("/health")
	public Map<String, String> health() {
		return Map.of("status", "UP", "message", "DevOps API is running smoothly");
	}

	@GetMapping("/tasks")
	public List<DevOpsTask> getAllTasks() {
		return repository.findAll();
	}

	@PostMapping("/tasks")
	public DevOpsTask createTask(@RequestBody DevOpsTask task) {
		return repository.save(task);
	}

	@PutMapping("/tasks/{id}")
	public DevOpsTask updateTask(@PathVariable Long id, @RequestBody DevOpsTask taskDetails) {
		DevOpsTask task = repository.findById(id).orElseThrow();
		task.setStatus(taskDetails.getStatus());
		task.setPriority(taskDetails.getPriority());
		return repository.save(task);
	}

	@DeleteMapping("/tasks/{id}")
	public void deleteTask(@PathVariable Long id) {
		repository.deleteById(id);
	}
}
