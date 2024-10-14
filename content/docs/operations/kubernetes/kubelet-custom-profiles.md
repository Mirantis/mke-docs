---
title: Kubelet Custom Profiles
weight: 2
---

You can deploy custom profiles to configure kubelet on a per-node basis.

A Kubelet custom profile is comprised of a profile name and a set of values. The profile name is used to identify the profile and to target it to specific nodes in the cluster, while the values are merged into the final Kubelet configuration that is applied to a target node.

## Creating a custom profile

You can specify custom profiles in the `kubelet.customProfiles` section of the MKE configuration file. Profiles must each have a unique name, and values can refer to fields in the kubelet configuration file.

For detail on all possible values, refer to the official Kubrernetes documentation [Set Kubelet Parameters Via a Configuration File](https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/).

The following example configuration creates a custom profile named `hardworker` that specifies thresholds for the garbage collection of images and eviction.

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

## Applying a custom profile to a node

Hosts can be assigned a custom profile through the `hosts` section of the MKE configuration file, whereas the profile name is an install time argument for the host.

The following example configuration applies the `hardworker` custom profile to the `localhost` node.

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

## Precedence of Kubelet configuration

The Kubelet configuration of each node is created by merging several different configuration sources. For MKE 4, the order is as follows:

1. Structured configuration values specified in the `kubelet` section of the MKE configuration, which is the lowest precedence.
2. Custom profile values specified in `kublelet.customProfiles`.
3. Runtime flags specified in `kubelet.extraArgs`, which is the highest precedence.

For more information on Kubelet configuration value precedence, refer to the official Kubernetes documentation [Kubelet configuration merging order](https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/#kubelet-configuration-merging-order).
