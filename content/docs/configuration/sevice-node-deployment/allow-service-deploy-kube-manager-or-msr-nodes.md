---
title: Allow services deployment on Kubernetes MKE manager
weight: 2
---

You can circumvent the protections put in place by [Kubernetes taints and
tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).
For details, refer to [Restrict services deployment to Kubernetes worker nodes](../restrict-service-deploy-to-kube-workers).

Schedule services deployment on manager and MSR nodes
-----------------------------------------------------

1. Log in to the MKE web UI with administrator credentials.

2. Click the user name at the top of the navigation menu.

3. Navigate to **Admin Settings** > **Orchestration**.

4. Select from the following options:

   *  Under **Container Scheduling**, toggle to the right the slider
      for **Allow administrators to deploy containers on MKE managers
      or nodes running MSR**.

   *  Under **Container Scheduling**, toggle to the right the slider
      for **Allow all authenticated users, including service accounts,
      to schedule on all nodes, including MKE managers and MSR nodes.**

Following any scheduling action, MKE applies a toleration to new workloads, to
allow the Pods to be scheduled on all node types. For existing workloads,
however, it is necessary to manually add the toleration to the Pod
specification.

Add a toleration to the Pod specification for existing workloads
----------------------------------------------------------------

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

{{< callout type="note" >}}

A ``NoSchedule`` taint is present on MKE manager and MSR nodes, and if you
disable scheduling on managers and/or workers a toleration for that taint
will not be applied to the deployments. As such, you should not schedule on
these nodes, except when the Kubernetes workload is deployed in the
``kube-system`` namespace.

{{< /callout >}}
