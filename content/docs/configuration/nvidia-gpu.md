---
title: NVIDIA GPU Workloads
weight: 6
---

Mirantis Kubernetes Engine (MKE) supports running workloads on NVIDIA GPU nodes.
Current support is limited to NVIDIA GPUs.

{{< callout type="info" >}}
GPU Feature Discovery (GFD) is enabled by default.
{{< /callout >}}

To manage your GPU resources and enable GPU support, MKE installs the NVIDIA
GPU Operator on your cluster. The use of this resource causes the following
resources to be installed and configured on each node:

* [GPU device driver](https://www.nvidia.com/en-us/drivers/)
* [NVIDIA GPU Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)
* [NVIDIA container runtime](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#configuring-containerd-for-kubernetes)

{{< callout type="info" >}}
Though it is not required, you can run the following command at any point to verify your GPU specifications:

```
sudo lspci | grep -i nvidia
```

Example output:

```
00:1e.0 3D controller: NVIDIA Corporation TU104GL [Tesla T4] (rev a1)
```

{{< /callout >}}

## Configuration

NVIDIA GPU support is disabled in MKE 4 by default.

**To enable NVIDIA GPU support:**

1. Obtain the mke4.yaml configuration file:

   ```
   mkectl init > mke4.yaml
   ```

2. Navigate to the `devicePlugins.nvidiaGPU` section of the mke4.yaml
   configuration file, and set the `enabled` parameter to `true`.

   ```yaml
   devicePlugins:
     nvidiaGPU:
       enabled: true
   ```

3. Apply the new configuration setting:

   ```
   mkectl apply -f mke4.yaml
   ```

{{< callout type="important" >}}
Pod startup time can vary depending on node performance, during which the Pods
will seem to be in a state of failure.
{{< /callout >}}

## Verification

Once your NVIDIA GPU support configuration has completed, you can verify your
setup using the tests detailed below:

### Detect NVIDIA GPU Devices

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

### Run a GPU Workload

Run the following command once the Pod has reached `Completed` status:

```
kubectl logs pod/cuda-vectoradd
```

Example output:

```
[Vector addition of 50000 elements]
Copy input data from the host memory to the CUDA device
CUDA kernel launch with 196 blocks of 256 threads
Copy output data from the CUDA device to the host memory
Test PASSED
Done
```

### Count GPUs

Run the following command once you have enabled the NVIDIA GPU Device Plugin
and the Pods have stabilized:

```
kubectl get nodes "-o=custom-columns=NAME:.metadata.name,GPUs:.metadata.labels.nvidia\.com/gpu\.count"
```

Example results, showing a cluster with 3 control-plane nodes and 3 worker nodes:

```
NAME                                           GPUs
ip-172-31-174-195.us-east-2.compute.internal   1
ip-172-31-228-160.us-east-2.compute.internal   <none>
ip-172-31-231-180.us-east-2.compute.internal   1
ip-172-31-26-15.us-east-2.compute.internal     <none>
ip-172-31-3-198.us-east-2.compute.internal     1
ip-172-31-99-105.us-east-2.compute.internal    <none>
```