from __future__ import annotations

from rest_framework import serializers


class DependencyHealthSerializer(serializers.Serializer):
    ok = serializers.BooleanField()
    detail = serializers.CharField()


class HealthDependenciesSerializer(serializers.Serializer):
    database = DependencyHealthSerializer()
    redis = DependencyHealthSerializer()


class HealthResponseSerializer(serializers.Serializer):
    service = serializers.ChoiceField(choices=["londonplan-api"])
    time = serializers.DateTimeField()
    correlation_id = serializers.CharField(allow_null=True)
    dependencies = HealthDependenciesSerializer()
