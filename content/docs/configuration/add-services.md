---
title: Add services
weight: 3
---

{{< callout type="info" >}}

**[k0rdent](https://k0rdent.io) is a Mirantis-initiated open source project that enables lifecycle management for services on MKE 4k clusters.**

{{< /callout >}}

Through the use of the `services` section of the `mke4.yaml` configuration
file, you can add additional components to your MKE 4k installation. This section will pass the input values through to k0rdent, following the
typical [k0rdent services
format](https://docs.k0rdent.io/latest/user/services/).

Example:

```yaml
services:
   - template: project-ingress-nginx-4.11.0
     name: ingress-nginx
     namespace: ingress
```

To learn more about the services sanctioned by k0rdent, refer to the [k0rdent
catalog](https://catalog.k0rdent.io/latest/).
