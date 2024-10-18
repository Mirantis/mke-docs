---
title: kubelet
weight: 2
---

The kubelet component runs on each node in a Kubernetes cluster, which serves
as the primary administrative agent for each node, monitoring application
servers and routing administrative requests to servers. You can configure
kubelet for all cluster nodes through the `kubelet` section of the MKE
configuration file, an example of which follows:

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
MKE configuration file. Profiles must each have a unique name, and values can
refer to fields in the kubelet configuration file.

For detail on all possible values, refer to the official Kubernetes
documentation [Set Kubelet Parameters Via A Configuration
File](https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/).

The following example configuration creates a custom profile named `hardworker`
that specifies thresholds for the garbage collection of images and eviction:

```yaml
spec:
  kubelet:
    customProfiles:
      - name: hardworker
        values:
          imageGCHighThresholdPercent: 85
          imageGCLowThresholdPercent: 80
          evictionHard:
            imagefs.available: 15%
            memory.available: 100Mi
            nodefs.available: 10%
            nodefs.inodesFree: 5%
```

### Apply a custom profile to a node

Hosts can be assigned a custom profile through the `hosts` section of the MKE
configuration file, whereas the profile name is an installation time argument for
the host.

The following example configuration applies the `hardworker` custom profile to
the `localhost` node:

```yaml
  hosts:
  - role: single
    ssh:
      address: localhost
      keyPath: ~/.ssh/id_rsa
      port: 22
      user: root
      installFlags:
        - --profile=hardworker
```

## Precedence of kubelet configuration

The kubelet configuration of each node is created by merging several different
configuration sources. For MKE 4, the order is as follows:

1. Structured configuration values specified in the `kubelet` section of the
   MKE configuration, which is the lowest precedence.
2. Custom profile values specified in `kublelet.customProfiles`.
3. Runtime flags specified in `kubelet.extraArgs`, which is the highest
   precedence.

For more information on kubelet configuration value precedence, refer to the
official Kubernetes documentation [Kubelet configuration merging
order](https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/#kubelet-configuration-merging-order).
