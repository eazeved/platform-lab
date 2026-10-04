# platform-lab

Hands-on internal developer platform used to practice Senior DevOps / Platform Engineering skills.
Everything is reproducible locally (kind) and on AWS (EKS via Terraform + Terragrunt).

## Stack
| Area | Tools |
|---|---|
| IaC | Terraform, Terragrunt, terraform test |
| Cluster | kind (local), EKS + Karpenter (cloud) |
| GitOps | Argo CD (app-of-apps), Argo Rollouts |
| Security | Kyverno, cosign, Syft (SBOM), Trivy, External Secrets |
| Observability | OpenTelemetry Collector, kube-prometheus-stack, Loki, Tempo, Sloth SLOs |
| App | Go microservice (`apps/demo`) with OTel, Prometheus metrics, Helm chart |
| CI | GitHub Actions with AWS OIDC (no static keys) |

## Quick start (local)
```bash
make tools      # check required CLIs
make up         # kind cluster + Argo CD + platform apps
make demo       # build demo image, load into kind, deploy
make argocd-ui  # port-forward Argo CD (admin password printed)
make down       # destroy everything
```

## Layout
```
infra/            Terraform modules + Terragrunt live config (dev/prod)
clusters/         Argo CD bootstrap + app-of-apps
platform/         Platform add-ons (Kyverno policies, ESO, Karpenter, cert-manager)
observability/    OTel Collector, SLO definitions, dashboards
apps/demo/        Go service, Dockerfile, Helm chart
.github/workflows CI pipelines
docs/adr/         Architecture Decision Records
runbooks/         Operational runbooks and postmortems
scripts/          Helper scripts
```

## Study roadmap
See [docs/ROADMAP.md](docs/ROADMAP.md) for the 12-week plan and checklist.
