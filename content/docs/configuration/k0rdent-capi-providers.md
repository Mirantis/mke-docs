---
title: k0rdent CAPI providers
weight: 6
---

Most k0rdent CAPI (Cluster API) providers are disabled in MKE4 by default. To
enable these providers, create a `k0rdent.providers` section in the `mke4.yaml`
configuration file and add them to it. The CAPI providers use the [same strings/names as those found in the k0rdent product](https://github.com/k0rdent/kcm?tab=readme-ov-file#extended-management-configuration).

```yaml
k0rdent:
  providers:
    - name: k0smotron
    - name: cluster-api-provider-azure
```

Currently, all CAPI providers are installed at cluster creation; however, once
the cluster is up and running, these providers are disabled. The one exception
is the Sveltos CAPI provider, which MKE 4 always adds and enables, as it is a
product dependency.