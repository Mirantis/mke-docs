---
weight: 3
---

# k0rdent templates

k0rdent templates are re-usable text definitions of components that you can use
to create and manage MKE 4 clusters. These templates provide a declarative way
for you to deploy and manage complex clusters or components while massively
reducing the number of parameters that require hands-on configuration.

## Benefits

k0rdent templates are:

* **Human readable and editable**: k0rdent templates use YAML as an abstraction
to represent the target state.

* **Usable in multiple contexts by way of runtime parameterization**: Through
the use of placeholders, you can customize templates at runtime without having
to directly edit the template.

* **Usable for both cluster creation and addon management**: You can use
k0rdent templates to define a cluster through YAML. You
can also define and manage addons for your clusters, such as an ingress
operator or monitoring tools.

* **Capable of limited scope deployment**: You can set restrictions over which
k0rdent templates can be deployed and by whom. For example, a platform manager
can configure a template so that non-admin users can only execute templates
that deploy a particular set of controllers.

## Template types ##

The k0rdent template types MKE 4 uses are cluster templates and service
templates.

### Cluster Templates ###

``ClusterTemplate`` objects, which are designed to be immutable, define
clusters in coordination with the clouds and infrastructures on which they are
run.

### Service Templates ###

``ServiceTemplate`` objects, which are designed to be immutable, define
services, addons, and workloads that run on clusters.