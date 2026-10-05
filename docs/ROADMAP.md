# 14-week roadmap

| Week | Topic | Deliverable in this repo | Done |
|---|---|---|---|
| 1 | Baseline + resume | repo bootstrap, pre-commit, `make up` | [ ] |
| 2-5 | CKA deep dive (see [docs/cka](cka/README.md)) | kubeadm cluster, break-it drills, killer.sh > 85%, exam passed | [ ] |
| 6 | IaC | `infra/modules/*` + `terraform test` green; EKS dev applied & destroyed | [ ] |
| 7 | CI/CD + supply chain | `ci.yaml` signing + SBOM; Kyverno verify-image in Enforce | [ ] |
| 8 | GitOps at scale | ApplicationSet multi-cluster, ESO + Secrets Manager, ADR 0001 | [ ] |
| 9 | Observability + SRE | OTel traces in Tempo, SLO burn-rate alerts firing, postmortem | [ ] |
| 10 | Security / CKS | Pod Security restricted Enforce, Falco, kube-bench report | [ ] |
| 11 | Networking + scale | Cilium + Hubble, Gateway API, Karpenter, KEDA, k6 + chaos | [ ] |
| 12 | Platform eng + FinOps | Backstage template, Crossplane RDS, OpenCost report | [ ] |
| 13 | Go + LLMOps | Go CLI/operator via GoReleaser; vLLM/Ollama on K8s with GPU metrics | [ ] |
| 14 | Interview prep | 5 system designs in `docs/interview/`, mocks recorded | [ ] |

## Exercises with the demo app
- Inject errors: `kubectl -n demo set env deploy/demo ERROR_RATE=0.2` and watch `DemoErrorBudgetFastBurn`.
- Canary auto-rollback: `helm upgrade demo apps/demo/chart -n demo --set rollout.enabled=true --set env.ERROR_RATE=0.3`.
- Latency SLO: `EXTRA_LATENCY_MS=400`.
- Chaos: `./scripts/chaos-kill-pod.sh` while running `k6 run tests/load/smoke.js`.
