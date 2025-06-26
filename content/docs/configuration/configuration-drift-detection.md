---
title: Configuration Drift Detection
weight: 12
---

Configuration drift is when operating environments deviate from a baseline or
standard configuration over time, causing these environments to become
inconsistent and unpredictable.

In MKE 4k clusters, drift detection is enabled by default for system services
and services that are specified in the cluster configuration. When any change
is detected in a specified resource, such as a label or specification, the
service state is automatically synced back to its original state as described
in the `mke4.yaml` configuration file.

By design, you cannot fully disable configuration drift detection, as doing so
could cause your MKE 4k cluster to become unstable. You can, however, configure
the system to ignore certain resources and specify certain resource fields for
exclusion from the detection process.

### Ignore specified resources

To stop certain resources from being tracked for configuration drift, add the
drift ignore patch selectors to the MKE 4k configuration. For example, the
following configuration will disable drift detection for the
`ingress-nginx-controller` deployment object in `ingress-nginx` namespace:

```
spec:
  driftDetection:
    driftIgnore:
      - group: apps
        version: v1
        kind: Deployment
        name: ingress-nginx-controller
        namespace: ingress-nginx
```

Thereafter, any changes made to resources deployed by MKE 4k itself will be
flagged as a configuration drift. Any modifications made directly to the
`ingress-nginx-controller` deployment, however, will not be detected as drift.

All patch selector parameters are optional, and you can specify any or all of
them to indicate which resources drift detection is to ignore.

The patch selector parameters are detailed in the following table:

| Parameter            | Description                                                                                |
|----------------------|--------------------------------------------------------------------------------------------|
| `group`              | API group from which to select resources.                                                         |
| `version`            | Version of the API group from which to select resources.                                          |
| `kind`               | Type of API group from which to select resources.                                           |
| `name`               | Name with which to match resources.                                                              |
| `namespace`          | The namespace from which to select resources.                                                        |
| `annotationSelector` | A string that follows the label selection expression, which matches with resource annotations. |
| `labelSelector`      | A string that follows the label selection expression, which matches with resource labels.      |

{{< callout type="warning" >}} You cannot filter resources by service using
patch selector parameters. Thus, if you decide to disable drift detection for
specific resources, ensure that the patch selector is set to filter only
required cluster resources. {{< /callout >}}

### Exclude specified fields

In addition to setting drift detection to ignore specified resources, you can
also use JSON Pointers to specify that only certain fields be excluded from
drift detection.

Example MKE 4k configuration:

```
spec:
  driftDetection:
    driftExclusions:
      - paths:
           - "/spec/replicas"
        target:
          group: apps
          version: v1
          kind: Deployment
          name: ingress-nginx-controller
          namespace: ingress-nginx
```
