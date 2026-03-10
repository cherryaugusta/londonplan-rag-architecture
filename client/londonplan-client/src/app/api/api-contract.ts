export type IsoDateTime = string;

export interface DependencyHealth {
  ok: boolean;
  detail: string;
}

export interface HealthDependencies {
  database: DependencyHealth;
  redis: DependencyHealth;
}

export interface HealthResponse {
  service: 'londonplan-api';
  time: IsoDateTime;
  correlation_id: string | null;
  dependencies: HealthDependencies;
}
