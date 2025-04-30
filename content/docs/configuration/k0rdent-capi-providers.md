---
title: k0rdent CAPI providers
weight: 6
---

Most k0rdent CAPI (Cluster API) providers are disabled in MKE4 by default. To
enable these providers, create a `k0rdent.providers` section in the `mke4.yaml`
configuration file and add them to it. The CAPI providers use the same strings/names as those found in the k0rdent product.

```yaml
k0rdent:
  providers:
    - name: k0smotron
    - name: cluster-api-provider-azure
```

{{< callout type="info" >}}

MKE 4 always adds and enables the `sveltos` CAPI provider, as this provider is
a product dependency.

{{< /callout >}}

Currently, all CAPI providers are installed at cluster creation, however once
the cluster is up and running the providers are disabled.