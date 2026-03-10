# ADR 0001: Security by design

## Status
Accepted

## Context
The project is intended as a portfolio-grade, regulated-style architecture sample. It must demonstrate secure defaults early, not as a later retrofit.

## Decision
We will:
- propagate correlation IDs across requests and responses
- use secret scanning with pre-commit
- use dependency auditing
- keep environment files out of Git
- enable secure browser-header defaults in Django
- version governance artifacts alongside code

## Consequences
- Slightly more setup work
- Better traceability
- Stronger portfolio signal for production-minded engineering
