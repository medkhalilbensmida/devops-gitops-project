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
    dashboardData: any = null;

    pipelineSteps = [
        { name: 'Build', status: 'success', icon: '📦' },
        { name: 'SAST Scan', status: 'success', icon: '🔍' },
        { name: 'SCA Analysis', status: 'success', icon: '🛡️' },
        { name: 'Docker Push', status: 'success', icon: '🐳' },
        { name: 'GitOps Sync', status: 'success', icon: '🔄' }
    ];

    constructor(private http: HttpClient) { }

    ngOnInit() {
        this.checkBackend();
        this.fetchDashboard();
    }

    checkBackend() {
        this.http.get('/api/status').subscribe({
            next: (data) => this.backendStatus = data,
            error: (err) => {
                this.backendStatus = { status: 'ERROR', message: 'Backend unreachable' };
            }
        });
    }

    fetchDashboard() {
        this.http.get('/api/dashboard').subscribe({
            next: (data) => this.dashboardData = data,
            error: (err) => console.error('Dashboard error:', err)
        });
    }
}
