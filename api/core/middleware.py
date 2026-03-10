from __future__ import annotations

import uuid

from django.http import HttpRequest, HttpResponse


class CorrelationIdMiddleware:
    header_name = "HTTP_X_CORRELATION_ID"

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request: HttpRequest) -> HttpResponse:
        raw_value = request.META.get(self.header_name, "")
        correlation_id = self._normalize_uuid(raw_value)
        request.correlation_id = correlation_id

        response = self.get_response(request)
        response["X-Correlation-ID"] = correlation_id
        return response

    def _normalize_uuid(self, value: str) -> str:
        try:
            return str(uuid.UUID(str(value)))
        except (ValueError, TypeError, AttributeError):
            return str(uuid.uuid4())
