---
title: Workload node deployment
weight: 10
---

By default, user workloads cannot run on manager nodes. This is to ensure that cluster
management functionality remains performant and to enhance cluster security.
You can, however, override this behavior.

{{< callout type="warning" >}}

If a user deploys a malicious workload that can affect
the node on which it is running, that workload will not be able to strike any
other nodes in the cluster or have any impact on cluster management
functionality.

{{< /callout >}}

Restrict workload deployment to Kubernetes worker nodes
-------------------------------------------------------

By default, MKE 4k clusters use [Kubernetes taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
to prevent user workloads from deploying to MKE 4k manager nodes.

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

Allow workload deployment on Kubernetes MKE 4k manager
------------------------------------------------------

You can circumvent the protections put in place by [Kubernetes taints and
tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

To add a toleration to the Pod specification for existing workloads:

1. Add the following toleration to the Pod specification, either through the
   MKE 4k web UI or using the `kubectl edit <resource> <name>` command:

   ```
   tolerations:
   - key: "node-role.kubernetes.io/master"
     operator: "Exists"
     effect: "NoSchedule"
   ```

2. Inspect the modified object to verify the successful application of the
   toleration.