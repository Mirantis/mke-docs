---
title: NVIDIA GPU Workloads
weight: 6
---

Mirantis Kubernetes Engine (MKE) supports running workloads on NVIDIA GPU nodes.
Current support is limited to NVIDIA GPUs. MKE uses the NVIDIA GPU Operator
to manage GPU resources on the cluster.

To enable GPU support, MKE installs the NVIDIA GPU Operator on your cluster.

## Prerequisites

Before you can enable NVIDIA GPU support in MKE, you must install the following components on each GPU-enabled node:

- The device [driver for your GPU](https://www.nvidia.com/en-us/drivers/)
- [NVIDIA GPU toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
- [NVIDIA container runtime](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#configuring-containerd-for-kubernetes) for containerd, using the command `sudo nvidia-ctk runtime configure --runtime=containerd --config /etc/k0s/containerd.d/nvidia.toml`

## Configuration

NVIDIA GPU support is disabled by default. To enable NVIDIA GPU support, configure
the `nvidiaGPU` section of the MKE configuration file under `devicePlugins`:

```yaml
devicePlugins:
  nvidiaGPU:
    enabled: true
```

## Running GPU Workloads

Run a simple GPU workload that reports detected NVIDIA GPU devices:

```yaml
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: gpu-pod
spec:
  restartPolicy: Never
  containers:
    - name: cuda-container
      image: nvcr.io/nvidia/cloud-native/gpu-operator-validator:v22.9.0
      resources:
        limits:
          nvidia.com/gpu: 1 # requesting 1 GPU
  tolerations:
  - key: nvidia.com/gpu
    operator: Exists
    effect: NoSchedule
EOF
```

Verify the successful completion of the pod:

```bash
kubectl get pods | grep "gpu-pod"
```

Example output:

```bash
NAME                        READY   STATUS    RESTARTS   AGE
gpu-pod                     0/1     Completed 0          7m56s
```

## Upgrading

To upgrade an MKE 3 cluster with GPU enabled, make sure that you complete the [GPU prerequisites](/mke-docs/docs/configuration/nvidia-gpu/#prerequisites) before you start the upgrade process. Failing to do this will cause the upgrade process to detect the GPU configuration in MKE 3 and incorrectly transfer it to MKE 4.
