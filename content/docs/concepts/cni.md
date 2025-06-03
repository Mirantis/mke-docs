---
title: Container Network Interface
weight: 4
---

{{< callout type="warning" >}}
To switch to a different CNI following initial CNI installation, you must first
reset your MKE 4k cluster.
{{< /callout >}}

MKE 4k supports Container Network Interface (CNI) plugins, to enable the
networking functionalities needed for container communication and management
within a cluster. CNI plugins that MKE 4k currently supports include:

- Kube-router
- Calico OSS
- Cilium

{{< callout type="important" >}}
Calico OSS is the only CNI that is supported for migrating configuration during
an MKE3 to MKE 4k upgrade.
{{< /callout >}}

## Configuration example

The `network` section of the `mke4.yaml` configuration file renders as follows:

```yaml
network:
    cplb:
      disabled: true
    kubeProxy:
      iptables:
        minSyncPeriod: 0s
        syncPeriod: 0s
      ipvs:
        minSyncPeriod: 0s
        syncPeriod: 0s
        tcpFinTimeout: 0s
        tcpTimeout: 0s
        udpTimeout: 0s
      metricsBindAddress: 0.0.0.0:10249
      mode: iptables
      nftables:
        minSyncPeriod: 0s
        syncPeriod: 0s
    multus:
      enabled: false
    nllb:
      disabled: true
    nodePortRange: 32768-35535
    providers:
    - enabled: true
      extraConfig:
        cidrV4: 192.168.0.0/16
        linuxDataplane: Iptables
        loglevel: Info
      provider: calico
    - enabled: false
      provider: custom
    - enabled: false
      extraConfig:
        cidrV4: 192.168.0.0/16
        v: "5"
      provider: kuberouter
    - enabled: false
      extraConfig:
        cidrV4: 192.168.0.0/16
        ciliumCNIExclusive: "true"
        ciliumIPAMMode: cluster-pool
        ciliumRoutingMode: tunnel
        ciliumTunnelProtocol: vxlan
      provider: cilium
    serviceCIDR: 10.96.0.0/16
```

## Network configuration

The following table includes details on all of the configurable `network` fields.

| Field | Description | Values |  Default |
|-------|-------------|--------|----------|
| `serviceCIDR` | Sets the IPv4 range of IP addresses for services in a Kubernetes cluster. | Valid IPv4 CIDR | `10.96.0.0/16` |
| `providers` | Sets the provider for the active CNI. | `calico` | `calico` |

## CNI providers configuration

### Kube-router

Configuration for the Kube-router CNI can be done by referring to the
documentation in https://github.com/cloudnativelabs/kube-router/blob/master/docs/user-guide.md#command-line-options. 

Two parameters [cidrV4 and v] are used to specify the ipv4 cidr and log level for the cluster.
Any other parameters specified in the extraConfig section of the CNI are passed as-is in the form 
of a key value pair by appending '--' before the key.

### Calico OSS

The following table includes details on the configurable settings
for the Calico provider.

| Field   | Description  | Values        |  Default     |
|---------|--------------|---------------|--------------|
| `enabled` | Sets the name of the external storage provider. AWS is currently the only available option. | `true` | `true` |
| `cidrV4` | Sets the IP pool in the Kubernetes cluster from which Pods are allocated. | Valid IPv4 CIDR | `192.168.0.0/16` <br><br>You can easily modify `cidrV4` prior to cluster deployment. Contact Mirantis Support, however, if you need to modify `clusterCIDRIPv4` once your cluster has been deployed.|
| `linuxDataplane` | Sets the dataplane for Calico CNI. | Iptables | Iptables|
| `loglevel` | Sets the log level for the CNI components. | Info, Debug | Info|

The default network configuration described herein offers a serviceable, low maintenance solution. If, however, you want more control over your network configuration environment, MKE 4k exposes maximal configuration for the Calico CNI through which you can configure your networking to the fullest extent allowed by the provider. For this, you will use the `values.yaml` key, in which case an example networking would resemble the following:

```yaml
 network:
    cplb:
      disabled: true
    kubeProxy:
      iptables:
        minSyncPeriod: 0s
        syncPeriod: 0s
      ipvs:
        minSyncPeriod: 0s
        syncPeriod: 0s
        tcpFinTimeout: 0s
        tcpTimeout: 0s
        udpTimeout: 0s
      metricsBindAddress: 0.0.0.0:10249
      mode: iptables
      nftables:
        minSyncPeriod: 0s
        syncPeriod: 0s
    multus:
      enabled: false
    nllb:
      disabled: true
    nodePortRange: 32768-35535
    serviceCIDR: 10.96.0.0/16
    providers:
    - enabled: true
      extraConfig:
        loglevel: Info
        values.yaml: |-
          kubeletVolumePluginPath: /var/lib/k0s/kubelet
          installation:
            logging:
              cni:
                logSeverity: Debug
            cni:
              type: Calico
            calicoNetwork:
              linuxDataplane: Iptables
              ipPools:
              - cidr: 192.168.0.0/15
                encapsulation: VXLAN
          resources:
            requests:
              cpu: 250m
          defaultFelixConfiguration:
            enabled: true
            wireguardEnabled: false
            wireguardEnabledV6: false
      provider: calico
    - enabled: false
      provider: custom
    - enabled: false
      extraConfig:
        cidrV4: 192.168.0.0/16
        v: "5"
      provider: kuberouter
```

{{< callout type="important" >}}

- You must choose whether to specify an exact YAML specification for the Helm installation of Tigera Operator during the initial cluster installation.
- The supplied YAML for `values.yaml` must include the exact first line `kubeletVolumePluginPath: /var/lib/k0s/kubelet`, otherwise the MKE 4k installation will fail.

{{< /callout >}}

{{< callout type="info" >}} Refer to the official Tigera Operator documentation
for:

- [Information on how to prepare the required content for the `values.yaml` specification](https://docs.tigera.io/calico/latest/getting-started/kubernetes/windows-calico/operator)
- The [`values.yaml` information content](https://docs.tigera.io/calico/latest/reference/installation/api#operator.tigera.io/v1.Installation)
- The [`defaultFelixConfiguration` content for the `values.yaml` specification(https://docs.tigera.io/calico/latest/reference/resources/felixconfig)

You can view the full `values.yaml` specification for the Helm chart needed to install Tigera Operator at the [Project Calico GitHub](https://github.com/projectcalico/calico/blob/master/charts/tigera-operator/values.yaml).

{{< /callout >}}
The network configuration generated as a result of upgrading to MKE 4k from an existing MKE 3 cluster always uses YAML. As such clusters have at least one existing IP pool, however, the CIDR and dataplane values are specified outside of the YAML, as illustrated below:

```yaml
  network:
    cplb:
      disabled: true
    kubeProxy:
      iptables:
        minSyncPeriod: 0s
        syncPeriod: 0s
      ipvs:
        minSyncPeriod: 0s
        syncPeriod: 0s
        tcpFinTimeout: 0s
        tcpTimeout: 0s
        udpTimeout: 0s
      metricsBindAddress: 0.0.0.0:10249
      mode: iptables
      nftables:
        minSyncPeriod: 0s
        syncPeriod: 0s
    multus:
      enabled: false
    nllb:
      disabled: true
    nodePortRange: 30000-32768
    serviceCIDR: 10.96.0.0/16
    providers: 
    - enabled: true
      extraConfig:
        cidrV4: 192.168.0.0/15
        linuxDataplane: Iptables
        loglevel: DEBUG
        values.yaml: |-
          kubeletVolumePluginPath: /var/lib/k0s/kubelet
          installation:
            registry: ghcr.io/mirantiscontainers/
            cni:
              type: Calico
            calicoNetwork:
              bgp: Disabled
              linuxDataplane: Iptables
          resources:
            requests:
              cpu: 250m
          tigeraOperator:
            version: v1.37.1
            registry: ghcr.io/mirantiscontainers/
          defaultFelixConfiguration:
            enabled: true
            bpfConnectTimeLoadBalancing: TCP
            bpfHostNetworkedNATWithoutCTLB: Enabled
            bpfLogLevel: Debug
            floatingIPs: Disabled
            logSeverityScreen: Debug
            logSeveritySys: Debug
            reportingInterval: 0s
            vxlanPort: 4789
            vxlanVNI: 10037
      provider: calico
    - enabled: false
      provider: custom
```

{{< callout type="info" >}}
- MKE 4k uses a static port range for Kubernetes NodePorts, from  `32768` to `35535`. 
- Following a successful MKE 3 to MKE 4k upgrade, a list displays that presents the ports that no longer need to be opened on manager or worker nodes. These ports can be blocked.
{{< /callout >}}

### Cilium

The following table includes details on the configurable settings
for the Cilium CNI provider.

| Field   | Description  | Values        |  Default     |
|---------|--------------|---------------|--------------|
| `enabled` | Sets Cilium as the primary CNI in MKE 4k cluster. | Boolean | `False` |
| `extraConfig.cidrV4` | Sets the IP pool in the Kubernetes cluster from which Pods are allocated. | Valid IPv4 CIDR | `192.168.0.0/16` <br><br>You can easily modify `cidrV4` prior to cluster deployment.|
| `extraConfig.ciliumIPAMMode` | Sets the IP address management  mode for Cilium CNI.| [Cilium IPAM documentation](https://docs.cilium.io/en/stable/network/concepts/ipam/) | cluster-pool|
| `extraConfig.ciliumRoutingMode` | Sets the routing method for Pod traffic between nodes.| `native`, `tunnel` | `tunnel`|
| `extraConfig.ciliumTunnelProtocol` | Defines the underlying encapsulation protocol for Pod traffic between nodes when tunneling is enabled.| `vxlan`, `geneve` | `vxlan` |
| `extraConfig.ciliumCNIExclusive` | Set to run Cilium in exclusive mode. |  Boolean | `True` |
| `extraConfig.values.yaml` | User-defined Cilium configuration. | String | Empty |

The default network configuration for Cilium CNI provides a reliable,
low-maintenance setup. MKE 4k, though, exposes the full range of configuration
options for the Cilium CNI, should you require greater control over your
networking environment. Using the `extraConfig.values.yaml` file, you can
customize your network settings extensively, to match the capabilities offered
by your infrastructure provider.

Example `extraConfig.values.yaml` file:

```yaml
- enabled: true
  extraConfig:
    values.yaml: |-
      tunnelProtocol: vxlan
      autoDirectNodeRoutes: false
      ipam:
        mode: cluster-pool
        operator:
          clusterPoolIPv4PodCIDRList: ["192.168.0.0/16"]
  provider: cilium
```

{{< callout type="important" >}}
To provide a custom configuration using the `extraConfig.values.yaml` file, you
must apply the it during the initial cluster installation.
{{< /callout >}}

To view the full `values.yaml` specification for the
helm chart that is needed to install Cilium, refer to the [cilium / cilium GitHub](https://github.com/cilium/cilium/blob/main/install/kubernetes/cilium/values.yaml).

{{< callout type="info" >}} If plan to use advanced eBPF features with the Cilium CNI, you should disable Multus or use it with caution. To
enable Multus requires that you set `cni.exclusive=false`, which limits the
effectiveness of the Cilium eBPF-based datapath on additional interfaces.
{{</callout >}}

## Limitations

- MKE 4k does not support Calico Enterprise. 
- Only clusters that use the default Kubernetes proxier `iptables` can be
  upgraded from MKE3 to MKE 4k.
- Only KDD-backed MKE 3 clusters can be upgraded to MKE 4k. Refer to [Upgrade
  from MKE 3.7 or 3.8](../../upgrade-from-MKE-3) for more information.
- Cilium CNI only supports fresh MKE 4k installations.
- Upgrade to MKE 4k from MKE 3.7 or MKE 3.8 is not supported when Cilium is
  installed as an unmanaged CNI.
