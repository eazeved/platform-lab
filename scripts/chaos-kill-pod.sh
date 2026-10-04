#!/usr/bin/env bash
# Minimal chaos experiment: kill a random demo pod and measure recovery.
set -euo pipefail
NS=${1:-demo}
pod=$(kubectl -n "$NS" get pods -l app.kubernetes.io/name=demo -o name | shuf -n1)
echo "Killing $pod at $(date -u +%T)"
start=$(date +%s)
kubectl -n "$NS" delete "$pod" --wait=false
kubectl -n "$NS" rollout status deploy/demo --timeout=120s
echo "Recovered in $(( $(date +%s) - start ))s"
