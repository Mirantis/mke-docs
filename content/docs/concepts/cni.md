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

## Notes
mke4 uses a static port range for k8s nodeports [32768-35535]. 
upgrade from mke3 to mke4 is only supported for clusters using the default k8s proxier (iptables)
only kdd backed mke3 clusters are supported for upgrading to mke4
once mke3 is successfully upgraded to mke4, it displays a list of ports that are no longer required to be opened on manager and/or worker nodes and could be blocked
