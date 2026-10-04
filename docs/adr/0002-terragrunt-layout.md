# ADR 0002: Terraform modules + Terragrunt live layout

- Status: accepted
- Date: 2026-10-03

## Context
Need DRY multi-environment config, isolated state per component, and explicit dependencies.

## Decision
Versioned modules under `infra/modules`, Terragrunt `live/<env>/<component>`, S3 backend with native lockfile (no DynamoDB).

## Alternatives considered
- Terraform workspaces: shared code path, but weak isolation and easy to apply to wrong env.
- Terraform Stacks / OpenTofu: worth evaluating; see TODO.

## Consequences
Small blast radius per state; `run --all` for orchestration; mock_outputs for planning without dependencies applied.
