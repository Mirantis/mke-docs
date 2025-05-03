---
title: kubelet
weight: 2
---

The kubelet component runs on each node in a Kubernetes cluster, which serves
as the primary administrative agent for each node, monitoring application
servers and routing administrative requests to servers. You can configure
kubelet for all cluster nodes through the `kubelet` section of the `mke4.yaml` configuration file, an example of which follows:

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

You can further configure a kubelet using the `extraArgs` field to define
flags. This field accepts a list of key-value pairs, which are passed directly
to the kubelet process at runtime.

Example extraArgs field configuration:

```yaml
spec:
  kubelet:
    extraArgs:
      event-burst: 100
      event-qps: 50
```

You can also configure a kubelet with custom profiles. Such profiles offer
greater control of the `KubeletConfiguration` and can be targeted to specific
hosts.

## kubelet custom profiles

You can deploy custom profiles to configure kubelet on a per-node basis.

A kubelet custom profile comprises a profile name and a set of values.
The profile name identifies the profile and targets it to specific
nodes in the cluster, while the values are merged into the final kubelet
configuration that is applied to a target node.

### Create a custom profile

You can specify custom profiles in the `kubelet.customProfiles` section of the
`mke4.yaml` configuration file. Profiles must each have a unique name, and
values can refer to fields in the kubelet configuration file.

For detail on all possible values, refer to the official Kubernetes
documentation [Set Kubelet Parameters Via A Configuration
File](https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/).

The following example configuration creates a custom profile named `worker_profile_1`
that specifies thresholds for the garbage collection of images and eviction:

```yaml
spec:
  kubelet:
    customProfiles:
      - name: worker_profile_1
        values:
          imageGCHighThresholdPercent: 85
          imageGCLowThresholdPercent: 80
          evictionHard:
            imagefs.available: 15%
            memory.available: 100Mi
            nodefs.available: 10%
            nodefs.inodesFree: 5%
```

{{< callout type="warning" >}}
To ensure your custom profile works correctly:

- Cross-check `featureGates` in the custom profile against the official
  Kubernetes [list of removed feature gates](https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates-removed/), as adding a removed feature gate will prevent the kubelet from starting. 
- Include only namespaced `sysctls` when you configure `allowedUnsafeSysctls`, as non-namespaced `sysctls` are unsupported by the kubelet and will prevent
  it from starting.
{{< /callout >}}

### Apply a custom profile to a node

You can assign a custom profile through the `hosts` section of the `mke4.yaml` configuration file, whereas the profile name is an installation time argument
for the host.

The following example configuration applies the `worker_profile_1` custom profile to
the `localhost` node:

```yaml
hosts:
  - role: controller+worker
    ssh:
      address: 52.37.200.22
      keyPath: ~/.ssh/id_rsa
      port: 22
      user: ubuntu
  - role: worker
    ssh:
      address: 18.236.186.188
      keyPath: ~/.ssh/id_rsa
      port: 22
      user: ubuntu
    installFlags:
      - --profile=worker_profile_1
```

### Debug worker profiles

If an invalid worker profile is provided, the kubelet assigned to use the profile may
fail to start. If a node takes on the `NotReady` state following the application of a worker
profile, it is likely due to an incorrect worker profile configuration.

To debug a worker profile:

1. SSH into the corresponding `NotReady` node.
2. Check the logs of k0sworker system service `journalctl -u k0sworker` for errors. 
3. If the worker node does not show any errors, SSH into a manager node.
4. Check the logs of the k0scontroller system service
   `journalctl -u k0scontroller` for errors. Repeat the process for every
   manager node until you find errors related to kubelet or to worker profiles.

Example of a k0scontroller error caused by an incorrect value for the
`memoryThrottlingFactor` parameter in the worker profile:

```bash
k0s[1619032]: time="2024-11-11 22:25:03" level=error msg="Failed to recover from previously failed reconciliation" component=workerconfig.Reconciler error="failed to generate resources for worker configuration: failed to decode worker profile \"worker_profile_1\": error unmarshaling JSON: while decoding JSON: json: cannot unmarshal string into Go struct field KubeletConfiguration.memoryThrottlingFactor of type float64"
```

## Precedence of kubelet configuration

The kubelet configuration of each node is created by merging several different
configuration sources. For MKE 4k, the order is as follows:

1. Structured configuration values specified in the `kubelet` section of the
   `mke4.yaml` configuration file, which is the lowest precedence.
2. Custom profile values specified in `kublelet.customProfiles`.
3. Runtime flags specified in `kubelet.extraArgs`, which is the highest
   precedence.

For more information on kubelet configuration value precedence, refer to the
official Kubernetes documentation [Kubelet configuration merging
order](https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/#kubelet-configuration-merging-order).
