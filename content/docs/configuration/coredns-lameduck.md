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


<callout type="info"> MKE 4 does not support the use of the ‘kubectl edit’ command to edit the CoreDNS config map outside of MKE for the purpose of configuring the lameduck function. Any such changes will be overwritten by the values set in the MKE configuration file whenever you execute the 'mkectl apply' command.</callout>

## Applying configuration

1. Enable or adjust the lameduck configuration.
2. Wait for the CoreDNS pods to apply the changes.
3. Check the CoreDNS logs to verify if the lameduck configuration is applied.

```bash
kubectl logs -f deployment/coredns -n kube-system
```

Example output:

```bash
Found 2 pods, using pod/coredns-5d78c9869d-7qfnd
.:53
[INFO] plugin/reload: Running configuration SHA512 = 591cf328cccc12bc490481273e738df59329c62c0b729d94e8b61db9961c2fa5f046dd37f1cf888b953814040d180f52594972691cd6ff41be96639138a43908
CoreDNS-1.10.1
linux/arm64, go1.20, 055b2c3

[INFO] Reloading
[INFO] plugin/reload: Running configuration SHA512 = 26fe33ee13757f04c8c9a1caebd7c6f0614306c92089ea215f1a8663f95ff1e673d4fa5de544b31492231923d4679370ce8735823ce3b5e65e5c23a9029c4512
[INFO] Reloading complete
```

## MKE version comparison

**Lameduck configuration parameters**

| MKE 3                                                 | MKE 4                                                                                                                                                                                                                                                                                                                                                                                                                |
|-------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [cluster_config.core_dns_lameduck_config.enabled]     |  dns.lameduck.enabled                                                                                                                                                                                                                                                                                                                                                                                           |
| [cluster_config.core_dns_lameduck_config.duration]    |  dns.lameduck.duration                                                                                                                                                                                                                                                                                                                                                                                       |

