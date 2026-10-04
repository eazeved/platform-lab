SHELL := /bin/bash
CLUSTER ?= platform-lab
IMG ?= demo:dev

.PHONY: tools up down argocd platform demo argocd-ui grafana test lint tf-test

tools: ## Check required CLIs
	@./scripts/check-tools.sh

up: tools ## Create kind cluster and bootstrap GitOps
	kind create cluster --name $(CLUSTER) --config clusters/kind/kind-config.yaml || true
	$(MAKE) argocd

argocd:
	kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -n argocd --server-side -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl -n argocd rollout status deploy/argocd-server --timeout=300s
	kubectl apply -f clusters/bootstrap/root-app.yaml

demo: ## Build and load demo app into kind
	docker build -t $(IMG) apps/demo
	kind load docker-image $(IMG) --name $(CLUSTER)
	helm upgrade --install demo apps/demo/chart -n demo --create-namespace \
	  --set image.repository=demo --set image.tag=dev --set image.pullPolicy=Never

argocd-ui:
	@echo "admin password:"; kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
	kubectl -n argocd port-forward svc/argocd-server 8080:443

grafana:
	kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80

test: ## Go unit tests
	cd apps/demo && go test ./... -race -cover

lint:
	pre-commit run --all-files

tf-test:
	cd infra/modules/vpc && terraform init -backend=false && terraform test

down: ## Destroy local cluster
	kind delete cluster --name $(CLUSTER)
