# Runbook: demo high error rate (DemoErrorBudgetFastBurn)

## Impact
Users receive 5xx; 30-day error budget consumed at >=14.4x.

## Triage (5 min)
1. Recent change? `kubectl argo rollouts get rollout demo -n demo` / `helm history demo -n demo` / Argo CD history.
2. Scope: `sum by (code) (rate(http_requests_total{job="demo"}[5m]))` in Grafana.
3. Pods healthy? `kubectl -n demo get pods -o wide`, `kubectl -n demo describe pod <p>`.
4. Logs: Grafana Explore → Loki `{namespace="demo"} |= "error"`.
5. Traces: Tempo, filter `status=error`.

## Mitigate
- Bad release → `kubectl argo rollouts abort demo -n demo` or `helm rollback demo -n demo`.
- Config flag → revert in Git (GitOps), never hot-patch without a follow-up PR.
- Capacity → check HPA `kubectl -n demo get hpa`.

## Afterwards
Write postmortem using `runbooks/postmortem-template.md`.
