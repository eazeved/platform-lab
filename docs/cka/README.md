# CKA deep dive (4 weeks, ~12-15 h/week)

Exam: 2 h, ~15-20 performance-based tasks on live clusters, pass = 66%. Re-check the current
Kubernetes version and curriculum at https://github.com/cncf/curriculum before booking.

| Domain | Weight |
|---|---|
| Troubleshooting | 30% |
| Cluster Architecture, Installation & Configuration | 25% |
| Services & Networking | 20% |
| Workloads & Scheduling | 15% |
| Storage | 10% |

## Lab environment
- 3 VMs (1 control plane + 2 workers) with kubeadm: OrbStack/Multipass on the Mac or the home lab.
- Keep `kind` for fast drills; kubeadm for installation, upgrade, etcd and node troubleshooting.
- Use only kubernetes.io/docs while practicing (same as the exam).

## Week A — Cluster architecture & installation (25%)
- [ ] Install a cluster from scratch with kubeadm (containerd, CNI: Calico or Cilium)
- [ ] Join workers; regenerate join token (`kubeadm token create --print-join-command`)
- [ ] Upgrade control plane + workers one minor version (drain/cordon/uncordon)
- [ ] etcd backup/restore (`runbooks/etcd-backup-restore.md`) — 3 times, timed
- [ ] RBAC: Role/ClusterRole/Bindings, ServiceAccounts, `kubectl auth can-i --as`
- [ ] Create a user with a CSR + kubeconfig
- [ ] Helm install/upgrade/rollback; Kustomize overlays (`kubectl apply -k`)
- [ ] CRDs and operators: install one, inspect CRs
- [ ] Understand CRI/CNI/CSI interfaces and static pods

## Week B — Workloads, scheduling & storage (25%)
- [ ] Deployments: rolling update, rollback, `kubectl rollout history`
- [ ] ConfigMaps/Secrets as env and volumes
- [ ] Requests/limits, LimitRange, ResourceQuota, HPA (metrics-server)
- [ ] nodeSelector, affinity/anti-affinity, taints/tolerations, PriorityClass
- [ ] DaemonSet, Job/CronJob, init and sidecar containers
- [ ] StorageClass, dynamic provisioning, PV/PVC, access modes, reclaim policies, volume expansion

## Week C — Services, networking & troubleshooting (50%)
- [ ] Service types, EndpointSlices, headless services, CoreDNS debugging (`nslookup` from a pod)
- [ ] NetworkPolicy: default deny + allow rules (ingress and egress)
- [ ] Ingress and Gateway API (GatewayClass, Gateway, HTTPRoute)
- [ ] Troubleshoot: broken kubelet, wrong static pod manifest, certs, NotReady node
- [ ] Troubleshoot: CrashLoopBackOff, Pending (scheduling/PVC), ImagePullBackOff, failing probes
- [ ] Logs: `crictl`, `journalctl -u kubelet`, `kubectl logs --previous`, `kubectl events`

### Break-it drills (have a partner or script break things)
| Break | Expected fix |
|---|---|
| Wrong etcd path in kube-apiserver manifest | fix `/etc/kubernetes/manifests/kube-apiserver.yaml` |
| `systemctl stop kubelet` on a worker | restart/enable, check config |
| Delete CoreDNS ConfigMap entry | restore Corefile |
| Typo in Service selector | fix labels; check endpoints |
| Expired/missing kubeconfig cert | `kubeadm certs check-expiration` / renew |
| PVC bound to wrong StorageClass | recreate PVC |

## Week D — Exam simulation
- [ ] killer.sh session 1 (included with the exam) — do it under exam conditions, review every answer
- [ ] Re-do every failed task until done in < 6 min
- [ ] 2 extra timed mocks (KodeKloud CKA mock exams or similar)
- [ ] killer.sh session 2 two-three days before the exam
- [ ] Target: > 85% on killer.sh (it is harder than the real exam)

## Speed setup (practice until automatic)
```bash
alias k=kubectl
export do="--dry-run=client -o yaml"
export now="--force --grace-period 0"
k config use-context <ctx>        # ALWAYS switch context first on each task
k run tmp --image=busybox:1.36 --rm -it --restart=Never -- sh
k create deploy web --image=nginx $do > web.yaml
k explain pod.spec.containers --recursive | less
```
vim: `set ts=2 sw=2 et` in ~/.vimrc.

## Exam-day rules
- Read the context/namespace line of every task.
- Skip any task over ~8 min, flag it, come back.
- Verify each answer (`k get`, `k describe`, curl from a pod).

## Progress log
| Date | Mock | Score | Time | Weak areas |
|---|---|---|---|---|
