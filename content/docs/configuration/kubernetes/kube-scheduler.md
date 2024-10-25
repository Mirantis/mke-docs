---
title: kube-scheduler
weight: 5
---

The Kubernetes scheduler is a control plane process that assigns pods to nodes.
It first determines which nodes are valid placements for each pod in the
scheduling queue, according to constraints and available resources. Next,
kube-scheduler ranks each valid node and binds the pod to a node that is
suitable.

You can use multiple different schedulers within a cluster; kube-scheduler is
the reference implementation.

You can configure all Kubernetes controllers through the `scheduler` section of
the MKE configuration file, an example of which follows:

```yaml
spec:
  scheduler:
    profilingEnabled: true
    bindToAll: true
```

You can further configure Kubernetes Scheduler using the `extraArgs` field to
define flags. This field accepts a list of key-value pairs, which are passed
directly to the kube-scheduler process at runtime.