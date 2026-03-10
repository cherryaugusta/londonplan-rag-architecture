import { Component, OnInit, PLATFORM_ID, inject } from '@angular/core';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { HealthResponse } from '../../api/api-contract';
import { HealthService } from '../../api/health.service';

@Component({
  selector: 'app-health-check',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './health-check.html',
  styleUrl: './health-check.scss'
})
export class HealthCheckComponent implements OnInit {
  private readonly healthService = inject(HealthService);
  private readonly platformId = inject(PLATFORM_ID);

  health: HealthResponse | null = null;
  loading = false;
  error = '';

  ngOnInit(): void {
    if (isPlatformBrowser(this.platformId)) {
      this.loadHealth();
    }
  }

  loadHealth(): void {
    this.loading = true;
    this.error = '';

    this.healthService.getHealth().subscribe({
      next: (response) => {
        this.health = response;
        this.loading = false;
      },
      error: (err: unknown) => {
        console.error('Health check failed', err);
        this.error = 'Unable to load API health status.';
        this.loading = false;
      }
    });
  }
}
