# ADR 0001: Argo CD for GitOps in platform-lab

- Status: accepted
- Date: 2026-10-03

## Context
I have run both Flux (AKS monitoring stack at Carbigdata) and Argo CD (NTConsult, MadeInWeb).
The lab needs multi-cluster app delivery, progressive delivery and a UI for demos.

## Decision
Argo CD with app-of-apps + sync waves; Argo Rollouts for canary.

## Alternatives considered
| Option | Pros | Cons |
|---|---|---|
| Flux | Lightweight, native Kustomize/Helm controllers, good multi-tenancy | No first-party UI; Flagger needed for canary |
| Argo CD | UI, ApplicationSets, SSO/RBAC (Keycloak OIDC), Rollouts integration | Heavier, repo-server tuning at scale |

## Consequences
- Easy to demo in interviews.
- TODO: ApplicationSet for multi-cluster (dev kind + EKS); Argo CD SSO via Keycloak.
