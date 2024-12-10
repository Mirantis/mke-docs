---
title: Restrict services deployment to Kubernetes worker nodes
weight: 1
---

By default, MKE clusters use [Kubernetes taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
to prevent user workloads from deploying to MKE manager nodes.

To view the taints, run the following command:

```
$ kubectl get nodes <mkemanager> -o json | jq -r '.spec.taints | .[]'
```

Example of system response:

```
{
  "effect": "NoSchedule",
  "key": "node-role.kubernetes.io/master"
}
```

