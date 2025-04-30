---
title: k0rdent CAPI providers
weight: 6
---

{{< callout type="info" >}}

**[k0rdent](https://k0rdent.io) is a Mirantis-initiated open source project that enables lifecycle management for services on MKE 4k clusters.**

{{< /callout >}}

k0rdent CAPI (Cluster API) providers allow for the creation and management of
child clusters directly in popular infrastructures.

Most k0rdent CAPI providers are disabled in MKE4 by default. To
enable these providers, create a `k0rdent.providers` section in the `mke4.yaml`
configuration file and add them to it. The CAPI providers use the [same
strings/names as those found in the k0rdent
product](https://github.com/k0rdent/kcm?tab=readme-ov-file#extended-management-configuration).

Example:

```yaml
k0rdent:
  enabled: true
  providers:
      - name: cluster-api-provider-azure
```

The offline configuration differs somewhat:

```yaml
k0rdent:
  enabled: true
  providers:
      - name: k0smotron-bootstrap
        config:
          images:
            k0smotronManager:
              repo: registry.local/k0rdent-enterprise
            kubeRbacProxyKubeRbacProxy:
              repo: registry.local/k0rdent-enterprise
      - name: k0smotron-control-plane
        config:
          images:
            k0smotronManager:
              repo: registry.local/k0rdent-enterprise
            kubeRbacProxyKubeRbacProxy:
              repo: registry.local/k0rdent-enterprise
      - name: k0smotron-infrastructure
        config:
          images:
            k0smotronManager:
              repo: registry.local/k0rdent-enterprise
            kubeRbacProxyKubeRbacProxy:
              repo: registry.local/k0rdent-enterprise
      - name: cluster-api-provider-aws
        config:
          images:
            clusterApiAwsControllerManager:
              repo: registry.local/k0rdent-enterprise
      - name: cluster-api-provider-azure
        config:
          images:
            azureserviceoperatorManager:
              repo: registry.local/k0rdent-enterprise
            clusterApiAzureControllerManager:
              repo: registry.local/k0rdent-enterprise
      - name: cluster-api-provider-openstack
        config:
          images:
            capiOpenstackControllerManager:
              repo: registry.local/k0rdent-enterprise
      - name: cluster-api-provider-vsphere
        config:
          images:
            clusterApiVsphereControllerManager:
              repo: registry.local/k0rdent-enterprise
```

Currently, several CAPI providers are installed at cluster creation; however,
once the cluster is up and running, these providers are disabled. A number of
CAPI providers are MKE 4 dependencies and are thus always added and enabled,
including Sveltos, CAPI, KCM, and mke-operator.

For information on each of the k0rdent CAPI providers, refer to the official
k0rdent documentation [Prepare k0rdent to create child clusters on multiple
providers](https://docs.k0rdent.io/v0.3.0/admin/installation/prepare-mgmt-cluster/?h=providers#prepare-k0rdent-to-create-child-clusters-on-multiple-providers).