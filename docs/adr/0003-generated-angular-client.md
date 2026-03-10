# ADR 0003: Generated Angular client

## Status
Accepted

## Context
Manual client code is fine early on, but generated clients reduce drift for stable endpoints.

## Decision
We will support both:
- a hand-written Angular service for the simple health feature
- a generated Angular API client derived from the locked OpenAPI schema

## Consequences
- Slightly more tooling
- Better demonstration of contract discipline
- Easier path to broader endpoint coverage
