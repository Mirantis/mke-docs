---
title: GPU Workloads
weight: 6
---

Mirantis Kubernetes Engine (MKE) supports running workloads on GPU nodes.
Current support is limited to NVIDIA GPUs. MKE uses the NVIDIA GPU Operator
to manage GPU resources on the cluster.

To enable GPU support, MKE will install the NVIDIA GPU Operator on your cluster.

## Prerequisites

Before you can enable GPU support in MKE, you must install the [NVIDIA GPU
toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
on each GPU enabled node in your cluster.

## Configuration

GPU support is disabled by default. To enable GPU support, you must configure
the `gpu` section of the MKE configuration file.

```yaml
gpu:
  enabled: true
```

This informs MKE to install the NVIDIA GPU Operator on your cluster.

## Running GPU Workloads

This example runs a simple GPU workload that reports detected NVIDIA GPU devices.

```yaml
kubectl apply -f- <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    run: gpu-test
  name: gpu-test
spec:
  replicas: 1
  selector:
    matchLabels:
      run: gpu-test
  template:
    metadata:
      labels:
        run: gpu-test
    spec:
      containers:
      - command:
        - sh
        - -c
        - "deviceQuery && sleep infinity"
        image: kshatrix/gpu-example:cuda-10.2
        name: gpu-test
        resources:
          limits:
            nvidia.com/gpu: "1"
EOF
```

Verify that the deployment is in a running state

```bash
kubectl get pods | grep "gpu-test"
```

You should see output similar to the following:

```bash
NAME                        READY   STATUS    RESTARTS   AGE
gpu-test-747d746885-hpv74   1/1     Running   0          14m
```

Review the logs of the `gpu-test` pod. `Result = PASS` indicates a successful
detection of the NVIDIA GPU device.

```bash
kubectl logs gpu-test-747d746885-hpv74
```

You should see output similar to the following:

```bash
deviceQuery Starting...

CUDA Device Query (Runtime API) version (CUDART static linking)

Detected 1 CUDA Capable device(s)

Device 0: "Tesla V100-SXM2-16GB"
...

deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 10.2, CUDA Runtime Version = 10.2, NumDevs = 1
Result = PASS
```

## Upgrading

If you are upgrading from an MKE3 cluster with GPU enabled, the [prerequisites](/docs/operations/gpu/#prerequisites)
must be done before starting the upgrade process. Otherwise, the upgrade will
see that the GPU is enabled in the MKE3 configuration and will transfer that
configuration to MKE4.
