import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { HealthResponse } from './api-contract';

@Injectable({ providedIn: 'root' })
export class HealthService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = '/api';

  getHealth(correlationId?: string): Observable<HealthResponse> {
    const headers = correlationId
      ? new HttpHeaders({ 'X-Correlation-ID': correlationId })
      : undefined;

    return this.http.get<HealthResponse>(`${this.baseUrl}/health/`, { headers });
  }
}
