#!/usr/bin/env bash
set -euo pipefail
missing=0
for t in docker kind kubectl helm terraform terragrunt go; do
  if command -v "$t" >/dev/null 2>&1; then
    printf '  ok      %s\n' "$t"
  else
    printf '  MISSING %s\n' "$t"; missing=1
  fi
done
if [[ $missing -eq 1 ]]; then
  echo "Install on macOS: brew install kind terragrunt cosign syft trivy kyverno" >&2
  exit 1
fi
