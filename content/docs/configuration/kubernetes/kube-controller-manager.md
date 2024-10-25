---
title: kube-controller-manager
weight: 4
---

The Kubernetes controller manager is a daemon that embeds the core control
loops that ship with Kubernetes. In Kubernetes, a controller is a control loop
that watches the shared state of the cluster through the kube-apiserver, making
changes designed to move the current state towards the desired state. Examples
of controllers that ship with Kubernetes are the replication controller,
endpoints controller, namespace controller, and the service accounts
controller.

You can configure all Kubernetes controllers through the `controllerManager`
section of the MKE configuration file, an example of which follows:

```yaml
spec:
  controllerManager:
    terminatedPodGCThreshold: 12500
```

You can further configure Kubernetes controller manager using the `extraArgs`
field to define flags. This field accepts a list of key-value pairs, which are
passed directly to the kube-controller-manager process at runtime.