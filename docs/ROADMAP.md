# 12-week roadmap

| Week | Topic | Deliverable in this repo | Done |
|---|---|---|---|
| 1 | Baseline + resume | repo bootstrap, pre-commit, `make up` | [ ] |
| 2-3 | Kubernetes deep dive / CKA | `runbooks/etcd-backup-restore.md` exercised on kubeadm | [ ] |
| 4 | IaC | `infra/modules/*` + `terraform test` green; EKS dev applied & destroyed | [ ] |
| 5 | CI/CD + supply chain | `ci.yaml` signing + SBOM; Kyverno verify-image in Enforce | [ ] |
| 6 | GitOps at scale | ApplicationSet multi-cluster, ESO + Secrets Manager, ADR 0001 | [ ] |
| 7 | Observability + SRE | OTel traces in Tempo, SLO burn-rate alerts firing, postmortem | [ ] |
| 8 | Security / CKS | Pod Security restricted Enforce, Falco, kube-bench report | [ ] |
| 9 | Networking + scale | Cilium + Hubble, Gateway API, Karpenter, KEDA, k6 + chaos | [ ] |
| 10 | Platform eng + FinOps | Backstage template, Crossplane RDS, OpenCost report | [ ] |
| 11 | Go + LLMOps | Go CLI/operator via GoReleaser; vLLM/Ollama on K8s with GPU metrics | [ ] |
| 12 | Interview prep | 5 system designs in `docs/interview/`, mocks recorded | [ ] |

## Exercises with the demo app
- Inject errors: `kubectl -n demo set env deploy/demo ERROR_RATE=0.2` and watch `DemoErrorBudgetFastBurn`.
- Canary auto-rollback: `helm upgrade demo apps/demo/chart -n demo --set rollout.enabled=true --set env.ERROR_RATE=0.3`.
- Latency SLO: `EXTRA_LATENCY_MS=400`.
- Chaos: `./scripts/chaos-kill-pod.sh` while running `k6 run tests/load/smoke.js`.
