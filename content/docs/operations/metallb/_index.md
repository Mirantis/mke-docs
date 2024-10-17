---
title: Metallb load balancer
weight: 3
---

MetalLB is a load balancer designed for bare metal Kubernetes clusters, utilizing standard routing protocols.

## Prerequisites
- An MKE cluster, which does not already have network load-balancing functionality.

- A cluster network configuration that is compatible with MetalLB.

- Verification that kube-proxy is running in iptables mode.

- Verification of the absence of any cloud provider configuration


## Configuration

You can configure MetalLB through the `Addons` section of the MKE 4 configuration file. The function is disabled by default and must be enabled for the cluster to function correctly.

1. Run `mkectl init` to obtain the default configuration file. The following example illustrates the MetalLB configuration section used to deploy MetalLB as a Helm chart within the cluster.

```yaml
spec:
  addons:
    - chart:
        name: metallb
        repo: https://metallb.github.io/metallb
        values: |
          controller:
            tolerations:
              - key: node-role.kubernetes.io/master
                operator: Exists
                effect: NoSchedule
          speaker:
            frr:
              enabled: false
        version: 0.14.7
      dryRun: false
      enabled: false
      kind: chart
      name: metallb
      namespace: metallb-system
```

2. Set the `enabled` field to `true` to enable MetalLB.
3. Run `mkectl apply -f [config-file]` to apply the configuration.
4. Verify the successful deployment of MetalLB in the cluster.
  ```bash
  kubectl get pods,services,deployments -n metallb-system -l app.kubernetes.io/name=metallb
  ```

  Sample output:
  ```bash
  NAME                                      READY   STATUS    RESTARTS   AGE
  pod/metallb-controller-79d6b8bb85-c2hrm   1/1     Running   0          17m
  pod/metallb-speaker-ccpdf                 1/1     Running   0          17m
  pod/metallb-speaker-x2pgf                 1/1     Running   0          17m

  NAME                              TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
  service/metallb-webhook-service   ClusterIP   10.96.8.155   none        443/TCP   17m

  NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
  deployment.apps/metallb-controller   1/1     1            1           17m
  ```


## Configuration parameters

The following table lists the default configuration parameters for MetalLB addon in MKE 4.

| Field                                 |       Description                                         | Default                                                                                   |
|---------------------------------------|-----------------------------------------------------------|-------------------------------------------------------------------------------------------|
| kind                                  | Indicates the kind of Addon                               | chart                                                                                     |
| enabled                               | Indicates whether the addon is enabled                    | false                                                                                     |
| name                                  | Indicates the name of the addon                           | metallb                                                                                   |
| namespace                             | Indicates the namespace used for deploying metallb        | metallb-system                                                                            |
| chart.name                            | Indicates the name of the metallb helm chart              | metallb                                                                                   |
| chart.repo                            | Indicates the metallb helm repository                     | https://metallb.github.io/metallb                                                         |
| chart.version                         | Indicates the version of the metallb helm chart           | 0.14.7                                                                                    |
| chart.values.controller.tolerations   | Indicates the tolerations for the metallb controller pod  | - key: node-role.kubernetes.io/master<br><br/>operator: Exists <br><br/>effect: NoSchedule|
| chart.values.speaker.frr.enabled      | Indicates whether FRR is enabled for metallb speaker      | false                                                                                     |




## MKE version comparison: Metallb configuration parameters

| MKE-3                                                          | MKE-4                                   |
|----------------------------------------------------------------|-----------------------------------------|
| [cluster_config.metallb_config.enabled]                        | addons.metallb.enabled                  |
| [[cluster_config.metallb_config.metallb_ip_addr_pool]]         | `Deprecated`                            |


## IP address pool configuration

<callout type="info"> Support for IP address pool configuration has been deprecated in MKE 4. Users are now required to manage this configuration independently. </callout>

### Create IP address pools in a fresh installation

For information on how to create IP address pools, the users can refer metallb documentation. [Configuring IP address pools](https://metallb.universe.tf/configuration/#layer-2-configuration)

#### Example

The following configuration gives MetalLB control over IPs from 192.168.1.240 to 192.168.1.250, and configures Layer 2 mode.

```yaml
---
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: cheap
  namespace: metallb-system
spec:
  addresses:
  - 192.168.10.0/24
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: empty
  namespace: metallb-system
```

For advanced configuration, refer to [Advanced Configuration](https://metallb.universe.tf/configuration/_advanced_ipaddresspool_configuration)

### Managing IP address pools during upgrade

During the upgrade, if metalLB is enabled in MKE 3, the configured IP address pool details are displayed in upgrade summary.

#### Example

MetalLB enabled in MKE 3 with the following configuration.

```toml
[cluster_config.metallb_config]
  enabled = true

  [[cluster_config.metallb_config.metallb_ip_addr_pool]]
    name = "example1"
    external_ip = ["192.168.10.0/24", "192.168.1.0/24"]
  [[cluster_config.metallb_config.metallb_ip_addr_pool]]
    name = "example2"
    external_ip = ["192.155.10.0/24"]
```

The related upgrade summary provides the following information.

```bash
MetalLB IP address pools
---------------
name: example1
ipaddress: [192.168.10.0/24 192.168.1.0/24]

name: example2
ipaddress: [192.155.10.0/24]

Please make sure that you create these pools after MKE4 installation is complete.
```

Users are advised to review the information included in the upgrade summary for guidance on creating IP address pools. You may either use this template or consult the MetalLB documentation on [Configuring IP Address Pools](https://metallb.universe.tf/configuration/#layer-2-configuration) for assistance with the creation of IP address pools.

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: example1
  namespace: metallb-system
spec:
  addresses:
  - 192.168.10.0/24
  - 192.168.1.0/24
---
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: example2
  namespace: metallb-system
spec:
  addresses:
  - 192.155.10.0/24
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: empty
  namespace: metallb-system
```

## Uninstall MetalLB

To uninstall MetalLB from the cluster, set the `enabled` field to `false` in the configuration file and run `mkectl apply -f [config-file]`.


