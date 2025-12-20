import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';

@Component({
    selector: 'app-root',
    standalone: true,
    imports: [CommonModule],
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
    title = 'DevOps Platform';
    backendStatus: any = { status: 'Checking...', message: 'Initializing connection to API...' };

    pipelineSteps = [
        { name: 'Build', status: 'success', icon: '📦' },
        { name: 'SAST Scan', status: 'success', icon: '🔍' },
        { name: 'Docker Push', status: 'success', icon: '🐳' },
        { name: 'GitOps Sync', status: 'pending', icon: '🔄' }
    ];

    constructor(private http: HttpClient) { }

    ngOnInit() {
        this.checkBackend();
    }

    checkBackend() {
        this.http.get('/api/status').subscribe({
            next: (data) => this.backendStatus = data,
            error: (err) => {
                this.backendStatus = {
                    status: 'ERROR',
                    message: 'Could not connect to backend. Make sure it is running at /api'
                };
            }
        });
    }
}
