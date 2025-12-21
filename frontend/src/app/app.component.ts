import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';

interface DevOpsTask {
    id?: number;
    title: string;
    description: string;
    status: string;
    priority: string;
    createdAt?: string;
}

@Component({
    selector: 'app-root',
    standalone: true,
    imports: [CommonModule, FormsModule],
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
    title = 'DevOps Platform';
    backendStatus: any = { status: 'Checking...', message: 'Connecting to API...' };
    tasks: DevOpsTask[] = [];

    newTask: DevOpsTask = {
        title: '',
        description: '',
        status: 'TODO',
        priority: 'MEDIUM'
    };

    constructor(private http: HttpClient) { }

    ngOnInit() {
        this.checkBackend();
        this.loadTasks();
    }

    checkBackend() {
        this.http.get<any>('/api/health').subscribe({
            next: (data) => this.backendStatus = data,
            error: () => this.backendStatus = { status: 'OFFLINE', message: 'Backend unreachable' }
        });
    }

    loadTasks() {
        this.http.get<DevOpsTask[]>('/api/tasks').subscribe({
            next: (data) => this.tasks = data,
            error: () => console.error('Failed to load tasks')
        });
    }

    addTask() {
        if (!this.newTask.title) return;
        this.http.post<DevOpsTask>('/api/tasks', this.newTask).subscribe({
            next: (task) => {
                this.tasks.push(task);
                this.newTask = { title: '', description: '', status: 'TODO', priority: 'MEDIUM' };
            }
        });
    }

    updateTaskStatus(task: DevOpsTask, newStatus: string) {
        task.status = newStatus;
        this.http.put(`/api/tasks/${task.id}`, task).subscribe();
    }

    deleteTask(id: number) {
        this.http.delete(`/api/tasks/${id}`).subscribe({
            next: () => this.tasks = this.tasks.filter(t => t.id !== id)
        });
    }

    getTasksByStatus(status: string) {
        return this.tasks.filter(t => t.status === status);
    }
}
