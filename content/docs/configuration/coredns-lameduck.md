---
title: CoreDNS Lameduck
weight: 6
---

Adding lameduck to the health plugin minimizes DNS resolution failures during a CoreDNS pod restart or deployment rollout. 
Mirantis Kubernetes Engine (MKE) supports enabling lameduck for the default server block.


## Configuration

CoreDNS lameduck support is disabled by default. To enable lameduck, configure
the `lameduck` section of the MKE configuration file under `dns`:

```yaml
  dns:
    lameduck:
      enabled: true
      duration: "7s"
```

**Configuration parameters**

| Field                      | Description                                                             | Default |
|----------------------------|-------------------------------------------------------------------------|---------|
| enabled                    | Enables the lameduck health function.<br/>  Valid values: true, false.  | false   |
| duration                   | Length of time during which lameduck will run, expessed with integers and time suffixes, such as s for seconds and m for minutes.                                            | 7s      |


<callout type="info"> MKE 4 does not support the use of the `kubectl edit` command to edit the CoreDNS config map outside of MKE for the purpose of configuring the lameduck function. Any such changes will be overwritten by the values set in the MKE configuration file whenever you execute the `mkectl apply` command.</callout>

## Applying configuration

1. Enable or adjust the lameduck configuration.
2. Wait for the CoreDNS pods to apply the changes.
3. Check the error logs to verify that CoreDNS lameduck is running.

   ```bash
   kubectl get configmap coredns
   ```

## MKE version comparison

**Lameduck configuration parameters**

| MKE 3                                                 | MKE 4                                                                                                                                                                                                                                                                                                                                                                                                                |
|-------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [cluster_config.core_dns_lameduck_config.enabled]     |  dns.lameduck.enabled                                                                                                                                                                                                                                                                                                                                                                                           |
| [cluster_config.core_dns_lameduck_config.duration]    |  dns.lameduck.duration                                                                                                                                                                                                                                                                                                                                                                                       |

