import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';

import { HealthService } from '../generated-api-client/api/health.service';
import { HealthResponse } from '../generated-api-client/model/healthResponse';

@Injectable({ providedIn: 'root' })
export class GeneratedHealthService {
  private readonly api = inject(HealthService);

  getHealth(): Observable<HealthResponse> {
    return this.api.healthRetrieve();
  }
}
