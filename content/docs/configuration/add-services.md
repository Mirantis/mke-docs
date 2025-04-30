---
title: Add services
weight: 3
---

Through the use of the `services` section of the `mke4.yaml` configuraiton
file, you can add outside components to your MKE 4 installation. Basically, the
`services` section will pass the input values through to k0rdent, following the
typical [k0rdent services
format](https://docs.k0rdent.io/latest/user/services/).

Example:

```yaml
services:
   - template: project-ingress-nginx-4.11.0
      name: ingress-nginx
      namespace: ingress
```