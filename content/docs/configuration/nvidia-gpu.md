---
title: NVIDIA GPU Workloads
weight: 6
---

Mirantis Kubernetes Engine (MKE) supports running workloads on NVIDIA GPU nodes.
Current support is limited to NVIDIA GPUs.

To manage your GPU resources and enable GPU support, MKE installs the NVIDIA
GPU Operator on your cluster. The use of this resource causes the following
resources to be installed and configured on each node:

* GPU Operator driver
* Toolkit
* container runtime

{{< callout type="info" >}}
GPU Feature Discovery (GFD) is enabled by default.
{{< /callout >}}

{{< callout type="important" >}}
Pod startup requires several minutes. During this period, the Pods will seem to
be in a state of failure.
{{< /callout >}}

## Configuration

NVIDIA GPU support is disabled in MKE 4 by default.

**To enable NVIDIA GPU support:**

1. Obtain the default MKE 4 configuration file:

   ```
   mkectl init
   ```

2. Navigate to the `devicePlugins.nvidiaGPU` section of the configuration
   file, and set the `enabled` parameter to `true`.

   ```yaml
   devicePlugins:
     nvidiaGPU:
       enabled: true
   ```

3. Apply the configuration:

   ```
   mkectl apply -f <mke-configuration-file>
   ```

4. Verify the successful deployment of MetalLB in the cluster:

   <!-- COMMAND AND EXAMPLE OUTPUT NEEDED, as in Multus topic -->

## Run GPU Workloads

1. Run a simple GPU workload that reports detected NVIDIA GPU devices:

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

2. Verify the successful completion of the Pod:

   ```bash
   kubectl get pods | grep "gpu-pod"
   ```

   Example output:

   ```bash
   NAME                        READY   STATUS    RESTARTS   AGE
   gpu-pod                     0/1     Completed 0          7m56s
   ```
