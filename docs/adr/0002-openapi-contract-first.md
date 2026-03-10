# ADR 0002: OpenAPI contract first

## Status
Accepted

## Context
The frontend and backend must stay aligned while the platform evolves.

## Decision
We will expose an OpenAPI schema from Django using drf-spectacular and lock the exported schema into version control.

## Consequences
- API changes become visible in diffs
- Contract drift is easier to detect
- Generated clients become practical
