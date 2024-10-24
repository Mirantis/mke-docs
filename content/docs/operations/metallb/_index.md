---
title: Metallb load balancer
weight: 3
---

MetalLB is a load balancer designed for bare metal Kubernetes clusters that uses standard routing protocols.

## Prerequisites

- An MKE cluster that does not already have load-balancing functionality.

- A MetalLB-compatible cluster network configuration.

- `kube-proxy` running in `iptables` mode.

- The absence of any cloud provider configuration.


## Configuration

You configure MetalLB through the `Addons` section of the MKE 4 configuration file. The function is disabled by default, and thus to use MetalLB you must set the `enabled` parameter to `true`.

1. Obtain the default configuration file.

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
3. Apply the configuration:

  ```bash
  mkectl apply -f <mke-configuration-file>
  ```
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
  service/metallb-webhook-service   ClusterIP   10.96.8.155   none          443/TCP   17m

  NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
  deployment.apps/metallb-controller   1/1     1            1           17m
  ```


## Configuration parameters

  The default configuration parameters for the MetalLB add-on are detailed in the following table:

| Field                               | Description                                             | Default                                                                                                               |
|-------------------------------------|---------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| kind                                | Kind of add-on                                          | chart                                                                                                                 |
| enabled                             | Enablement state of add-on                              | false                                                                                                                 |
| name                                | Name of the add-on                                      | metallb                                                                                                               |
| namespace                           | Namespace used for deploying metallb                    | metallb-system                                                                                                        |
| chart.name                          | Name of the metallb helm chart                          | metallb                                                                                                               |
| chart.repo                          | Metallb helm repository                                 | https://metallb.github.io/metallb                                                                                     |
| chart.version                       | Version of the metallb helm chart                       | 0.14.7                                                                                                                |
| chart.values.controller.tolerations | Tolerations for the metallb controller pod              | ```yaml</br><br>- key: node-role.kubernetes.io/master</br><br>operator: Exists</br><br>effect: NoSchedule</br><br>``` |
| chart.values.speaker.frr.enabled    | Enablement state of FRR with regard to metallb speaker  | false                                                                                                                 |



## MKE version comparison: Metallb configuration parameters

| MKE-3                                                          | MKE-4                                   |
|----------------------------------------------------------------|-----------------------------------------|
| [cluster_config.metallb_config.enabled]                        | addons.metallb.enabled                  |
| [[cluster_config.metallb_config.metallb_ip_addr_pool]]         | `Deprecated`                            |
|----------------------------------------------------------------|-----------------------------------------|


## IP address pool configuration

  <callout type="info"> Support for IP address pool configuration is deprecated in MKE 4, and thus you must now independently manage the configuration. </callout>

### Create IP address pools in a fresh installation

  For information on how to create IP address pools, refer to the official MetalLB documentation, [Layer 2 configuration](https://metallb.universe.tf/configuration/#layer-2-configuration).

#### Example
  The following example configuration gives MetalLB control over IPs from 192.168.1.240 to 192.168.1.250, and configures Layer 2 mode.

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

  As necessary, refer to the official MetalLB documentation, [Advanced AddressPool](https://metallb.universe.tf/configuration/_advanced_ipaddresspool_configuration).

### Managing IP address pools during upgrade

  During an upgrade from MKE 3 to MKE 4, if metalLB is enabled in the former the configured IP address pool details display in the upgrade summary.

#### Example
  The following example configuration presents MetalLB enabled in MKE 3:

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

  The upgrade summary presents as follows:

  ```bash
  MetalLB IP address pools
  ---------------
  name: example1
  ipaddress: [192.168.10.0/24 192.168.1.0/24]

  name: example2
  ipaddress: [192.155.10.0/24]

  Please make sure that you create these pools after MKE4 installation is complete.
  ```

  Refer to the upgrade summary for guidance in the creation of IP address pools. To create the pools, you can use the template that follows or consult the official MetalLB documentation [Layer 2 configuration](https://metallb.universe.tf/configuration/#layer-2-configuration) for assistance.

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

  1. Obtain the configuration file.
  2. Set the `enabled` field to `false` to disable MetalLB.

    ```bash
    mkectl <mke-configuration-file>
    ```
  3. Apply the configuration:

    ```bash
    mkectl apply -f <mke-configuration-file>
    ```
