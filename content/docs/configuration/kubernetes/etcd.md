---
title: etcd
weight: 2
---

etcd is a consistent and highly-available key value store used as Kubernetes' backing store for all cluster data.

You can find in-depth information about etcd in the official [documentation](https://etcd.io/docs/).

You can configure etcd through the `etcd` section of the MKE configuration file, an example of which follows:

```yaml
spec:
  etcd:
    storageQuota: 2GB
    tlsCipherSuites: TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256
```
