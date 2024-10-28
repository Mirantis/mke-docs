---
title: MKE Dashboard
weight: 6
---

{{< callout type="info" >}} Available since 4.0.0-alpha.2.0 {{< /callout >}}

The MKE Dashboard add-on provides a web UI with which you can manage
Kubernetes resources:

![MKE dasboard preview](ui-preview.png)

To access the MKE Dashboard, which is enabled by default, navigate to the
address of the load balancer endpoint from a freshly-installed cluster. Refer
to [Load balancer requirements](../../getting-started/system-requirements#load-balancer-requirements) for detailed information.

To disable the MKE Dashboard, set the `enabled` field to `false`
in the `dashboard` section of the `config.yaml` file:

```yaml
   dashboard:
     enabled: false
```