---
title: Service node deployment
weight: 10
---

You can configure MKE to allow users to deploy and run services in worker
nodes only, to ensure that all cluster management functionality remains
performant and to enhance cluster security.

{{< callout type="warning" >}}

If for whatever reason a user deploys a malicious service that can affect
the node on which it is running, that service will not be able to strike any
other nodes in the cluster or have any impact on cluster management
functionality.

{{< /callout >}}

Restrict services deployment to Kubernetes worker nodes
-------------------------------------------------------

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

Allow services deployment on Kubernetes MKE manager
---------------------------------------------------

You can circumvent the protections put in place by [Kubernetes taints and
tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).
For details, refer to [Restrict services deployment to Kubernetes worker nodes](../restrict-service-deploy-to-kube-workers).

To add a toleration to the Pod specification for existing workloads:

1. Add the following toleration to the Pod specification, either through the
   MKE web UI or using the `kubectl edit <object> <workload>` command:

   ```
   tolerations:
   - key: "node-role.kubernetes.io/master"
     operator: "Exists"
   ```

2. Run the following command to confirm the successful application of the
   toleration:

   ```
   kubectl get <object> <workload> -o json | jq -r '.spec.template.spec.tolerations | .[]'
   ```

Example of system response:

```
{
"key": "node-role.kubernetes.io/master",
"operator": "Exists"
}
```

{{< callout type="caution" >}}

A ``NoSchedule`` taint is present on MKE manager nodes, and if you
disable scheduling on managers and/or workers a toleration for that taint
will not be applied to the deployments. As such, you should not schedule on
these nodes, except when the Kubernetes workload is deployed in the
``kube-system`` namespace.

{{< /callout >}}
