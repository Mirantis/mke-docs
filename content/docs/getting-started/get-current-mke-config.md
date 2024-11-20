---
title: Get the current MKE configuration file
weight: 6
---

To obtain the current MKE 4 configuration file from your MKE 4 cluster, run:

```shell
mkectl --kubeconfig ~/.mke/mke.kubeconf config get
```

There are numerous reasons why you may need to procure the MKE 4 configuration
file, including:

* To make changes to your MKE 4 configuration using the MKE 4 web UI or kubectl,
you can obtain the current MKE 4 configuration file and edit the settings as
needed. Following this, you can run `mkectl apply` to apply the new settings,
without the danger of the local configurations overwriting the changes.

* In the event that the MKE 4 configuration file is lost or becomes corrupted.
