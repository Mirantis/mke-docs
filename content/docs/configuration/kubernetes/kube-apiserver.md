---
title: kube-apiserver
weight: 3
---

The Kubernetes API server validates and configures data for the API objects,
which include pods, services, and replication controllers, among others. The
server performs REST operations while also serving as the frontend to the
shared state of a cluster, through which the other components interact.

You can configure the Kubernetes API server for all controllers through the
`apiServer` section of the MKE configuration file, an example of which follows:

```yaml
spec:
  apiServer:
    audit:
      enabled: false
      logPath: /var/lib/k0s/audit.log
      maxAge: 30
      maxBackup: 10
      maxSize: 10
    encryptionProvider: /var/lib/k0s/encryption.cfg
    eventRateLimit:
      enabled: false
    requestTimeout: 1m0s
```

You can further configure the Kubernetes API server using the `extraArgs` field
to define flags. This field accepts a list of key-value pairs, which are passed
directly to the kube-apiserver process at runtime.
