---
title: Known issues
weight: 2
---

This section describes the MKE 4 known issues with available workarounds.

## [BOP-708] OIDC authentication fails after mkectl upgrade

Due to an issue with client secret migration, OIDC authentication fails
following an upgrade performed with `mkectl`.

**Workaround:**

1. Copy the MKE 4 configuration that prints at the end of migration.

2. Update the `authentication.oidc.clientSecret` field to the secret field
   from your identity provider.

3. Apply the updated MKE 4 configuration.

## [BOP-686] kubectl fails during MKE 3.x to 4.x migration

For a cluster with multiple controller nodes, [k0s requires the presence of
a load balancer for the controller node](https://docs.k0sproject.io/head/high-availability/ ).
Without a load balancer, the controller nodes is unable to reach the kubelet on worker
nodes, and thus the user will be presented with `No agent available` errors.

**Workaround:**

1. If an external load balancer is not already in place, create one that
   targets all controllers and forwards the following ports:

   - `443` for controller
   - `6443` for Kubernetes API
   - `8132` for Konnectivity

2. Use `k0sctl` to update the `k0s` config to set `externalAddress`:

   ```yaml
   k0s:
     config:
       spec:
         api:
           externalAddress: <load balancer public ip address>
           sans:
           - <load balancer public ip address>
   ```
