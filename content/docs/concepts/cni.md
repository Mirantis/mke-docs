---
title: Container Network Interface
weight: 4
---

MKE supports both the Kuberouter and Calico OSS Container Network Interface (CNI) plugins,
to enable the networking functionalities needed for container communication
and management within a cluster:

1. Calico OSS
2. Kuberouter

{{< callout type="warning" >}}

Only Calico OSS CNI is supported for migrating configuration during the MKE3 to MKE4 upgrade.

{{< /callout >}}

## Configuration example

The `network` section of the MKE configuration file renders as follows:

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
```

## Network configuration

The following table includes details on all of the configurable `network` fields.

| Field | Description | Values |  Default |
|-------|-------------|--------|----------|
| `serviceCIDR` | Sets the IPv4 range of IP addresses for services in a Kubernetes cluster. | Valid IPv4 CIDR | `10.96.0.0/16` |
| `providers` | Sets the provider for the active CNI. | `calico` | `calico` |

## Providers configuration

### Kuberouter CNI

Configuration for the kube-router CNI can be done by referring to the
documentation in https://github.com/cloudnativelabs/kube-router/blob/master/docs/user-guide.md#command-line-options. 

Two parameters [cidrV4 and v] are used to specify the ipv4 cidr and log level for the cluster.
Any other parameters specified in the extraConfig section of the CNI are passed as-is in the form 
of a key value pair by appending '--' before the key.

### Calico CNI

The following table includes details on the configurable settings
for the Calico provider.

| Field   | Description  | Values        |  Default     |
|---------|--------------|---------------|--------------|
| `enabled` | Sets the name of the external storage provider. AWS is currently the only available option. | `true` | `true` |
| `cidrV4` | Sets the IP pool in the Kubernetes cluster from which Pods are allocated. | Valid IPv4 CIDR | `192.168.0.0/16` <br><br>You can easily modify `cidrV4` prior to cluster deployment. Contact Mirantis Support, however, if you need to modify `clusterCIDRIPv4` once your cluster has been deployed.|
| `linuxDataplane` | Sets the dataplane for Calico CNI. | Iptables | Iptables|
| `loglevel` | Sets the log level for the CNI components. | Info, Debug | Info|

The above configuration should suffice if you are OK with the default networking configuration and/or
desire to minimize efforts around network configuration. However if you want the ability to configure
networking beyond the above, MKE4 also exposes maximal configuration for the Calico provider. This allows
you to configure networking to the fullest extent allowed by the Calico CNI. To do this, you need to use
the values.yaml key. An example networking would then look like the following:

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

[^0]: The choice of whether to specify exact yaml spec for Helm installation of tigera-operator must be made while initially installing the cluster
[^1]: MKE4 installation will fail if the supplied yaml for values.yaml does not include the exact first line `kubeletVolumePluginPath: /var/lib/k0s/kubelet`
[^2]  The full values.yaml spec for the Helm chart used to install tigera-operator can be seen in https://github.com/projectcalico/calico/blob/master/charts/tigera-operator/values.yaml. Refer to 
      Calico OSS documentation for tigera-operator to prepare the required contents in values.yaml. MKE4 does not mangle the yaml provided in values.yaml before passing it to the Helm installer
[^3]: Refer to https://docs.tigera.io/calico/latest/reference/installation/api#operator.tigera.io/v1.Installation for installation contents in values.yaml
[^4]: Refer to https://docs.tigera.io/calico/latest/reference/resources/felixconfig for defaultFelixConfiguration contents in values.yaml
[^5]: The network configuration generated after migrating an existing MKE3 cluster will always use yaml. However because such cluster have at least one existing ip pool, the cidr and dataplane 
      values will be specified outside of the yaml as shown below:

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
- MKE4 uses a static port range for Kubernetes NodePorts, from  `32768` to `35535`. 
- Following a successful MKE3 to MKE4 upgrade, a list displays that presents the ports that no longer need to be opened on manager or worker nodes. These ports can be blocked.
{{< /callout >}}

## Limitations

- MKE4 does not support Calico Enterprise. 
- Only clusters that use the default Kubernetes proxier `iptables` can be upgraded from MKE3 to MKE4.
- Only KDD-backed MKE3 clusters can be upgraded to MKE4.
