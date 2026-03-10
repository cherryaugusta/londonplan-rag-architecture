from __future__ import annotations

from unittest.mock import patch

from django.test import SimpleTestCase
from rest_framework.test import APIClient

from core.views import DependencyHealth


class HealthCheckTests(SimpleTestCase):
    def setUp(self) -> None:
        self.client = APIClient()

    @patch("core.views.HealthCheckView._check_db")
    @patch("core.views.HealthCheckView._check_redis")
    def test_health_returns_200_when_dependencies_ok(self, mock_redis, mock_db) -> None:
        mock_db.return_value = DependencyHealth(ok=True, detail="ok")
        mock_redis.return_value = DependencyHealth(ok=True, detail="ok")

        response = self.client.get("/api/health/")

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response["X-Correlation-ID"], response.json()["correlation_id"])

    @patch("core.views.HealthCheckView._check_db")
    @patch("core.views.HealthCheckView._check_redis")
    def test_health_returns_503_when_dependency_fails(self, mock_redis, mock_db) -> None:
        mock_db.return_value = DependencyHealth(ok=True, detail="ok")
        mock_redis.return_value = DependencyHealth(ok=False, detail="Redis unavailable")

        response = self.client.get("/api/health/")

        self.assertEqual(response.status_code, 503)

    @patch("core.views.HealthCheckView._check_db")
    @patch("core.views.HealthCheckView._check_redis")
    def test_health_replaces_invalid_correlation_id(self, mock_redis, mock_db) -> None:
        mock_db.return_value = DependencyHealth(ok=True, detail="ok")
        mock_redis.return_value = DependencyHealth(ok=True, detail="ok")

        response = self.client.get("/api/health/", HTTP_X_CORRELATION_ID="not-a-uuid")

        self.assertEqual(response.status_code, 200)
        self.assertNotEqual(response["X-Correlation-ID"], "not-a-uuid")

    @patch("core.views.HealthCheckView._check_db")
    @patch("core.views.HealthCheckView._check_redis")
    def test_health_preserves_valid_correlation_id(self, mock_redis, mock_db) -> None:
        mock_db.return_value = DependencyHealth(ok=True, detail="ok")
        mock_redis.return_value = DependencyHealth(ok=True, detail="ok")

        cid = "3e1f9d47-3a4d-4d2b-8b9b-54e8d0a4e8f7"
        response = self.client.get("/api/health/", HTTP_X_CORRELATION_ID=cid)

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response["X-Correlation-ID"], cid)
