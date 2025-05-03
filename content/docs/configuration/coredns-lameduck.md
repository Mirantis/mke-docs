---
title: CoreDNS Lameduck
weight: 6
---

Adding lameduck to the health plugin minimizes DNS resolution failures during a CoreDNS pod restart or deployment rollout. 
Mirantis Kubernetes Engine (MKE) 4k supports enabling lameduck for the default server block.


## Configuration

CoreDNS lameduck support is disabled by default. To enable lameduck, configure
the `lameduck` section of the `mke4.yaml` configuration file under `dns`:

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
| duration                   | Length of time during which lameduck will run, expressed with integers and time suffixes, such as s for seconds and m for minutes.                                            | 7s      |


<callout type="info"> MKE 4k does not support the use of the `kubectl edit`
command to edit the CoreDNS config map outside of MKE 4k for the purpose of
configuring the lameduck function. Any such changes will be overwritten by the
values set in the `mke4.yaml` configuration file whenever you execute the
`mkectl apply` command.</callout>

## Applying configuration

1. Enable or adjust the lameduck configuration.
2. Wait for the CoreDNS pods to apply the changes.
3. Check the CoreDNS logs to verify that the Pod is running and that it has
   applied the configuration without any errors.

   ```bash
   kubectl logs -f deployment/coredns -n kube-system
   ```

   Example output:

   ```bash
   Found 2 pods, using pod/coredns-5d78c9869d-7qfnd
   .:53
   [INFO] plugin/reload: Running configuration SHA512 = 591cf328cccc12bc490481273e738df59329c62c0b729d94e8b61db9961c2fa5f046dd37f1cf888b953814040d180f52594972691cd6ff41be96639138a43908
   CoreDNS-1.10.1
   go1.20, 055b2c3

   [INFO] Reloading
   [INFO] plugin/reload: Running configuration SHA512 = 26fe33ee13757f04c8c9a1caebd7c6f0614306c92089ea215f1a8663f95ff1e673d4fa5de544b31492231923d4679370ce8735823ce3b5e65e5c23a9029c4512
   [INFO] Reloading complete
   ```
4. View the ConfigMap to verify the configuration that was applied:

   ```bash
   kubectl describe configmap coredns -n kube-system
   ```

   Example output:

   ```bash
   Name:         coredns
   Namespace:    kube-system
   Labels:       k0s.k0sproject.io/stack=coredns
   Annotations:  k0s.k0sproject.io/last-applied-configuration:
                   {"apiVersion":"v1","data":{"Corefile":".:53 {\n    errors\n    health\n    ready\n    kubernetes cluster.local in-addr.arpa ip6.arpa {\n  ...
                 k0s.k0sproject.io/stack-checksum: df0a18b174e12f166824f894f447d08f

   Data
   ====
   Corefile:
   ----
   .:53 {
     cache 30
     errors
     forward . /etc/resolv.conf
     health {
       lameduck 7s
     }
     kubernetes cluster.local in-addr.arpa ip6.arpa {
       pods insecure
       ttl 30
       fallthrough in-addr.arpa ip6.arpa
     }
     loadbalance
     loop
     prometheus :9153
     ready
     reload
   }


   BinaryData
   ====

   Events:  <none>
   ```



## Lameduck configuration parameters

| Parameter                                                 | Description                                                                                                                                                                                                                                                                                                                                                                                                                |
|-------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| dns.lameduck.enabled     |  Set to `true` to enable lameduck functionality.                                                                                                                                                                                                                                                                                                                                                                   |
| dns.lameduck.duration    |  Amount of time in which to delay the shutdown of the CoreDNS Pod.                                                                                                                                                                                                                                                                                                                                                                                       |

