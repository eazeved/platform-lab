# Runbook: etcd backup and restore (kubeadm)

```bash
export ETCDCTL_API=3
CERTS="--cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key"

# Backup
etcdctl --endpoints=https://127.0.0.1:2379 $CERTS snapshot save /var/backups/etcd-$(date +%F).db
etcdutl snapshot status /var/backups/etcd-$(date +%F).db -w table

# Restore (control plane node)
etcdutl snapshot restore /var/backups/etcd-YYYY-MM-DD.db --data-dir /var/lib/etcd-restore
sudo sed -i 's#/var/lib/etcd#/var/lib/etcd-restore#' /etc/kubernetes/manifests/etcd.yaml
# kubelet restarts the static pod; verify:
kubectl get pods -A
```

Practice log:
| Date | Cluster | Time to restore | Notes |
|---|---|---|---|
