---
weight: 3
---

# Blueprints

All MKE 4 configuration files are translated into blueprints,
a file type that is used to create Kubernetes Custom Resources (CRDs)
that are also called blueprints. MKE 4 uses Blueprint Operator to manage blueprints and their assignments.

Blueprint files must be in Kubernetes YAML format,
and they must contain many of the same fields as a standard Kubernetes Object.

A blueprint comprises three sections:

<dl>
  <dt><strong>Kubernetes Provider</strong></dt>
  <dd>Details the settings for the provider. For the most part, the Kubernetes Provider section is managed by <code>mkectl</code>, independently of the user's MKE configuration file. </dd>
  <dt><strong>Infrastructure</strong></dt>
  <dd>Provides details that are used for the Kubernetes cluster; the <code>hosts</code> section of the MKE configuration file.</dd>
  <dt><strong>Components</strong></dt>
  <dd>Composed of addons that are specified in the MKE configuration file. The <code>mkectl</code> command transforms the configuration options
into specific settings for either Helm or Manifest type addons that are deployed into the cluster.</dd>
</dl>

To view a detailed blueprint of an MKE configuration, run the `mkectl init --blueprint` command.

{{< callout type="error" >}}

It is possible to directly modify a blueprint. However, such modifications are
considered advanced and support by MKE 4 is not assured.

{{< /callout >}}

See the Blueprint Operator [documentation](https://mirantiscontainers.github.io/blueprint/) for more details on blueprints.
