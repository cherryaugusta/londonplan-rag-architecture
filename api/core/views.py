from __future__ import annotations

from dataclasses import asdict, dataclass
from datetime import datetime, timezone

import redis
from django.conf import settings
from django.db import connections
from django.db.utils import OperationalError
from drf_spectacular.utils import OpenApiResponse, extend_schema
from rest_framework import status
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from .serializers import HealthResponseSerializer


@dataclass
class DependencyHealth:
    ok: bool
    detail: str


class HealthCheckView(APIView):
    @extend_schema(
        tags=["health"],
        responses={
            200: OpenApiResponse(response=HealthResponseSerializer),
            503: OpenApiResponse(response=HealthResponseSerializer),
        },
    )
    def get(self, request: Request) -> Response:
        db_health = self._check_db()
        redis_health = self._check_redis()

        payload = {
            "service": "londonplan-api",
            "time": datetime.now(timezone.utc),
            "correlation_id": getattr(request, "correlation_id", None),
            "dependencies": {
                "database": asdict(db_health),
                "redis": asdict(redis_health),
            },
        }

        serializer = HealthResponseSerializer(data=payload)
        serializer.is_valid(raise_exception=True)

        http_status = (
            status.HTTP_200_OK
            if db_health.ok and redis_health.ok
            else status.HTTP_503_SERVICE_UNAVAILABLE
        )

        response = Response(serializer.data, status=http_status)
        response["X-Correlation-ID"] = payload["correlation_id"] or ""
        return response

    def _check_db(self) -> DependencyHealth:
        try:
            connection = connections["default"]
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1;")
                cursor.fetchone()
            return DependencyHealth(ok=True, detail="ok")
        except OperationalError as exc:
            return DependencyHealth(ok=False, detail=f"Database unavailable: {exc}")
        except Exception as exc:
            return DependencyHealth(ok=False, detail=f"Database error: {exc}")

    def _check_redis(self) -> DependencyHealth:
        try:
            client = redis.Redis.from_url(settings.REDIS_URL)
            client.ping()
            return DependencyHealth(ok=True, detail="ok")
        except Exception as exc:
            return DependencyHealth(ok=False, detail=f"Redis unavailable: {exc}")
