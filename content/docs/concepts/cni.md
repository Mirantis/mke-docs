---
title: Container Network Interface
weight: 4
---

MKE supports Calico open-source as a Container Network Interface (CNI) plugin
to enable the networking functionalities needed for container communication
and management within a cluster.

{{< callout type="warning" >}}

Calico configuration is not migrated during the MKE 3 to 4 upgrade.

{{< /callout >}}

## Configuration example

The `network` section of the MKE configuration file renders as follows:

```yaml
network:
  serviceCIDR: 10.96.0.0/16
  nodePortRange: 32768-35535
  kubeProxy:
    disabled: false
    mode: iptables
    metricsbindaddress: 0.0.0.0:10249
    iptables:
      masqueradebit: null
      masqueradeall: false
      localhostnodeports: null
      syncperiod:
        duration: 0s
      minsyncperiod:
        duration: 0s
    ipvs:
      syncperiod:
        duration: 0s
      minsyncperiod:
        duration: 0s
      scheduler: ""
      excludecidrs: []
      strictarp: false
      tcptimeout:
        duration: 0s
      tcpfintimeout:
        duration: 0s
      udptimeout:
        duration: 0s
    nodeportaddresses: []
  nllb:
    disabled: true
  cplb:
    disabled: true
  providers:
  - provider: calico
    enabled: true
    CALICO_DISABLE_FILE_LOGGING: true
    CALICO_STARTUP_LOGLEVEL: DEBUG
    FELIX_LOGSEVERITYSCREEN: DEBUG
    clusterCIDRIPv4: 192.168.0.0/16
    deployWithOperator: false
    enableWireguard: false
    ipAutodetectionMethod: null
    mode: vxlan
    overlay: Always
    vxlanPort: 4789
    vxlanVNI: 10000
  - provider: kuberouter
    enabled: false
    deployWithOperator: false
  - provider: custom
    enabled: false
    deployWithOperator: false
```

## Network configuration

The following table includes details on all of the configurable `network` fields.

| Field | Description | Values |  Default |
|-------|-------------|--------|----------|
| `serviceCIDR` | Sets the IPv4 range of IP addresses for services in a Kubernetes cluster. | Valid IPv4 CIDR | `10.96.0.0/16` |
| `providers` | Sets the provider for the active CNI. | `calico` | `calico` |

## Providers configuration

The following table includes details on the configurable settings
for the Calico provider.

| Field   | Description  | Values        |  Default     |
|---------|--------------|---------------|--------------|
| `enabled` | Sets the name of the external storage provider. AWS is currently the only available option. | `true` | `true` |
| `clusterCIDRIPv4` | Sets the IP pool in the Kubernetes cluster from which Pods are allocated. | Valid IPv4 CIDR | `192.168.0.0/16` |
| `ipAutodetectionMethod` | Sets the autodetecting method for the IPv4 address for the host. | Provider specific[^0] | None |
| `mode` | Sets the IPv4 overlay networking mode. | `ipip`, `vxlan` | `vxlan` |
| `vxlanPort` | Sets the VXLAN port for the VXLAN mode. | Valid port number | `4789` |
| `vxlanVNI` | Sets the VXLAN VNI for the VXLAN mode. | Valid VNI number | `10000` |
| `CALICO_STARTUP_LOGLEVEL` | Sets the early log level for `calico/node`. | Provider specific[^0] | `DEBUG` |
| `FELIX_LOGSEVERITYSCREEN` | Sets the log level for `calico/felix`. | Provider specific[^0] | `DEBUG` |

[^0]: For the available values, consult your provider documentation.

{{< callout type="note" >}}
- MKE 4 uses a static port range for Kubernetes NodePorts, from  `32768` to `35535`. 
- Only clusters that use the the default Kubernetes proxier `iptables` can be upgraded from MKE 3 to MKE 4.
- Only KDD-backed MKE 3 clusters can be upgraded to MKE 4.
- Following a successful MKE 3 to MKE 4 upgrade, a list displays that presents the ports that no longer need to be opened on manager or worker nodes. These ports can be blocked.
{{< /callout >}}
