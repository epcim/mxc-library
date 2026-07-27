# Storage Service Stack

This directory contains cloud-native block-storage engines and dynamic volume orchestrators.

---

## 📦 Stack Components

* [**Longhorn Distributed Block Storage**](#-longhorn-distributed-block-storage)

---

## 💾 Longhorn Distributed Block Storage

Longhorn provisions highly available, replicated storage blocks across your Kubernetes cluster.

### 1. CSI Path Override (MicroK8s Specifics)
To ensure the dynamic CSI driver hooks cleanly into MicroK8s, we explicitly set the kubelet directory path:
```yaml
longhorn:
  csi:
    kubeletRootDir: /var/snap/microk8s/common/var/lib/kubelet
```

### 2. Host Multipath Conflict Fix
If volumes fail to mount with multipath device locks, blacklist the Longhorn virtual sd devices:
```text
# Add to /etc/multipath.conf
blacklist {
    devnode "^sd[a-z0-9]+"
}
```
Then restart the service on the worker nodes:
```bash
sudo systemctl restart multipath-tools
sudo systemctl restart multipathd
```

### 3. Preflight Install Checks
To ensure worker hosts satisfy iscsi and nfs dependencies before running the deployment:
```bash
# Fetch longhornctl checker tool
curl -sSfL -o longhornctl https://github.com/longhorn/cli/releases/download/v1.8.0/longhornctl-linux-amd64
chmod +x longhornctl

# Run preflight verification
./longhornctl check preflight
```

### 4. Raw Volume Data Recovery
If a node fails but replicas are intact under `/var/lib/longhorn/replicas`, run the longhorn-engine directly in Docker to mount and recover files:
```bash
export PVC="pvc-d4c31e83-efa6-43b2-a870-77363f33db21-0c59011a"
export PVCSIZE=$(cat $PVC/volume.meta | jq ".Size")

# Boot engine container in host network
docker run --rm -v /dev:/host/dev -v /proc:/host/proc -v $PWD/$PVC:/volume --privileged \
  longhornio/longhorn-engine:v1.8.0 launch-simple-longhorn $PVC $PVCSIZE

# Mount device loop locally in read-only mode to extract files safely
mkdir recovery-$PVC
mount -t ext4 -o ro,defaults /dev/longhorn/$PVC recovery-$PVC
```
