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

## Multi-Instance GPU (MIG) functionality

With the Multi-Instance GPU (MIG) setting, you can partition a GPU into
multiple instances, each with their own high-bandwidth memory, cache, and
compute cores. Thus, you can securely run multiple workloads in parallel
without them interfering with one another.

{{< callout type="info" >}}
Although MIG provides the flexibility to create partitions of various sizes,
MKE 4 currently supports scenarios in which all GPU partitions are the same size.
{{< /callout >}}

For comprehensive information on Multi-Instance GPU, refer to the [official NVIDIA documentation](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/gpu-operator-mig.html#about-multi-instance-gpu).

MIG is disabled by default in MKE 4. To enable the MIG function:

1. Obtain the default MKE 4 configuration file:

   ```
   mkectl init
   ```

2. Navigate to the `devicePlugins.nvidiaGPU.mig` section of the configuration
   file, and set the `enabled` parameter to `true`.

   ```yaml
   devicePlugins:
     nvidiaGPU:
       enabled: true
       mig:
         enabled: true
   ```

3. Apply the configuration:

   {{< callout type="warning" >}}
   Enabling MIG on a running GPU will cause all Pods to immediately reboot.
   {{< /callout >}}

   ```
   mkectl apply -f <mke-configuration-file>
   ```

4. Optional. You can apply a profile to a node using the `nvidia.com/mig.config:
   <MIG profile>`. Refer to the official NVIDIA documentation [Supported MIG
   Profiles](https://docs.nvidia.com/datacenter/tesla/mig-user-guide/#supported-mig-profiles) for more information.

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
