---
title: MKE Dashboard
weight: 6
---

{{< callout type="info" >}} Available since 4.0.0-alpha.2.0 {{< /callout >}}

The MKE Dashboard add-on provides a web UI that you can use to manage
Kubernetes resources:

![MKE Dashboard preview](ui-preview.png)

To access the MKE Dashboard, which is enabled by default, navigate to the
address of the load balancer endpoint from a freshly installed cluster. Refer
to [Load balancer requirements](../../getting-started/system-requirements#load-balancer-requirements) for detailed information.

To disable the MKE Dashboard, set the `enabled` field to `false`
in the `dashboard` section of the MKE 4 configuration file:

```yaml
   dashboard:
     enabled: false
```
