---
title: Kubernetes Components
weight: 2
---

MKE 4 uses K0s to deploy core Kubernetes components, including:

- kubelet
- kube apiserver
- kube-controller-manager
- kube-scheduler

You can configure these components through the MKE configuration file.

## kubelet

The kubelet component runs on each node in a Kubernetes cluster, which serves as the primary administrative agent for each node, monitoring application servers and routing administrative requests to servers. You can configure kubelet for all cluster nodes through the `kubelet` section of the MKE configuration file, an example of which follows:

```yaml
spec:
  kubelet:
    eventRecordQPS: 50
    maxPods: 110
    podPidsLimit: -1
    podsPerCore: 0
    protectKernelDefaults: false
    seccompDefault: false
    workerKubeReserved:
      cpu: 50m
      ephemeral-storage: 500Mi
      memory: 300Mi
    managerKubeReserved:
      cpu: 250m
      ephemeral-storage: 4Gi
      memory: 2Gi
```

You can further configure a kubelet using the `extraArgs` field to define flags. This field accepts a list of key-value pairs, which are passed directly to the kubelet process at runtime.

Example extraArgs field configuration:

```yaml
spec:
  kubelet:
    extraArgs:
      event-burst: 100
      event-qps: 50
```

You can also configure a kubelet with custom profiles. Such profiles offer greater control of the `KubeletConfiguration` and can be targeted to specific hosts.

## kube-apiserver

The Kubernetes API server validates and configures data for the API objects, which include pods, services, and replicationcontrollers, among others. The server performs REST operations while also serving as the frontend to the shared state of a cluster, through which the other components interact.

You can configure the Kubernetes API server for all controllers through the `apiServer` section of the MKE configuration file, an example of which follows:

```yaml
spec:
  apiServer:
    audit:
      enabled: false
      logPath: /var/lib/k0s/audit.log
      maxAge: 30
      maxBackup: 10
      maxSize: 10
    encryptionProvider: /var/lib/k0s/encryption.cfg
    eventRateLimit:
      enabled: false
    requestTimeout: 1m0s
```

You can further configure kube-apiserver using the `extraArgs` field to define flags. This field accepts a list of key-value pairs, which are passed directly to the kube-apiserver process at runtime.

## kube-controller-manager

The Kubernetes controller manager is a daemon that embeds the core control loops that ship with Kubernetes. In Kubernetes, a controller is a control loop that watches the shared state of the cluster through the kube-apiserver, making changes designed to move the current state towards the desired state. Examples of controllers that ship with Kubernetes are the replication controller, endpoints controller, namespace controller, and the service accounts controller.

You can configure all Kubernetes controllers through the `controllerManager` section of the MKE configuration file, an example of which follows:

```yaml
spec:
  controllerManager:
    terminatedPodGCThreshold: 12500
```

You can further configure kube-controller-manager using the `extraArgs` field to define flags. This field accepts a list of key-value pairs, which are passed directly to the kube-controller-manager process at runtime.

## kube-scheduler

The Kubernetes scheduler is a control plane process that assigns pods to nodes. It first determines which nodes are valid placements for each pod in the scheduling queue, according to constraints and available resources. Next, kube-scheduler ranks each valid node and binds the pod to a node that is suitable.

You can use multiple different schedulers within a cluster; kube-scheduler is the reference implementation.

You can configure all Kubernetes controllers through the `scheduler` section of the MKE configuration file, an example of which follows:

```yaml
spec:
  scheduler:
```

You can further configure kube-scheduler using the `extraArgs` field to define flags. This field accepts a list of key-value pairs, which are passed directly to the kube-scheduler process at runtime.
