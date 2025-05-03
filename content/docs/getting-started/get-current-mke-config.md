---
title: Obtain the current MKE 4k configuration file
weight: 7
---

To obtain the current `mke4.yaml` configuration file for your MKE 4k cluster, run:

```shell
mkectl --kubeconfig ~/.mke/mke.kubeconf config get
```

There are numerous reasons why you may need to procure the `mke4.yaml` configuration file, including:

* To make changes to your `mke4.yaml` configuration file using the MKE 4k web
UI or kubectl, you can obtain the current `mke4.yaml` configuration file and
edit the settings as needed. Following this, you can run `mkectl apply` to
apply the new settings, without the danger of the local configurations
overwriting the changes.

* In the event that the `mke4.yaml` configuration file is lost or becomes
  corrupted.
