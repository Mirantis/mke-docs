---
weight: 3
---

# k0rdent templates

{{< callout type="info" >}}

[k0rdent](https://k0rdent.io) is a Mirantis-initiated open source project with which platform engineers can build, automate, and manage Kubernetes platforms at scale. MKE 4k is adopting k0rdent technology to enable installation and management of services and components in a template-driven manner. k0rdent is available in MKE 4k as a technical preview only.

For more information on MKE 4k and k0rdent, [contact Mirantis Sales]([mirantis.com/contact).

{{< /callout >}}

k0rdent templates are re-usable text definitions of components that you can use
to install services. These templates provide a declarative way
for you to install and manage the lifecycles of components while greatly
reducing the number of parameters that require hands-on configuration.

## Benefits

k0rdent templates are:

* **Human readable and editable**: k0rdent templates use YAML as an abstraction
to represent the target state.

* **Usable in multiple contexts by way of runtime parameterization**: Through
the use of placeholders, you can customize templates at runtime without having
to directly edit the template.

* **Capable of limited scope deployment**: You can set restrictions over which
k0rdent templates can be deployed and by whom. For example, a platform manager
can configure a template so that non-admin users can only execute templates
that deploy a particular set of controllers.
