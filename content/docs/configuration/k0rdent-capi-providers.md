---
title: k0rdent CAPI providers
weight: 6
---

{{< callout type="info" >}}

[k0rdent](https://k0rdent.io) is a Mirantis-initiated open source project with which platform engineers can build, automate, and manage Kubernetes platforms at scale. MKE 4 is adopting k0rdent technology to enable installation and management of services and components in a template-driven manner. **k0rdent is available in MKE 4k as a technical preview only.**

For more information on MKE 4k and k0rdent, [contact Mirantis Sales]([mirantis.com/contact).

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

The offline configuration differs somewhat.
<br><br>

<details>

<summary>Supported k0rdent CAPI providers with additional airgap-specific settings</summary>

{{< callout type="important" >}}

For the providers detailed herein, `<registry-address>/<registry-project-path>`
must be the same registry and path to which you uploaded the offline bundle
when [preparing your offline environment](../../getting-started/offline-installation/#preparation).

{{< /callout >}}


```yaml
k0rdent:
  enabled: true
  providers:
    - name: k0smotron-bootstrap
      config:
        images:
          k0smotronManager:
            repo: <registry-address>/<registry-project-path>
          kubeRbacProxyKubeRbacProxy:
            repo: <registry-address>/<registry-project-path>
    - name: k0smotron-control-plane
      config:
        images:
          k0smotronManager:
            repo: <registry-address>/<registry-project-path>
          kubeRbacProxyKubeRbacProxy:
            repo: <registry-address>/<registry-project-path>
    - name: k0smotron-infrastructure
      config:
        images:
          k0smotronManager:
            repo: <registry-address>/<registry-project-path>
          kubeRbacProxyKubeRbacProxy:
            repo: <registry-address>/<registry-project-path>
    - name: cluster-api-provider-aws
      config:
        images:
          clusterApiAwsControllerManager:
            repo: <registry-address>/<registry-project-path>
    - name: cluster-api-provider-azure
      config:
        images:
          azureserviceoperatorManager:
            repo: <registry-address>/<registry-project-path>
          clusterApiAzureControllerManager:
            repo: <registry-address>/<registry-project-path>
    - name: cluster-api-provider-openstack
      config:
        images:
          capiOpenstackControllerManager:
            repo: <registry-address>/<registry-project-path>
    - name: cluster-api-provider-vsphere
      config:
        images:
          clusterApiVsphereControllerManager:
            repo: <registry-address>/<registry-project-path>
```
</details>

Currently, all CAPI providers are installed at cluster creation; however,
once the cluster is up and running, these providers are disabled. A number of
CAPI providers are MKE 4 dependencies and are thus always added and enabled,
including Sveltos, CAPI, KCM, and mke-operator.

For information on each of the k0rdent CAPI providers, refer to the official
k0rdent documentation [Prepare k0rdent to create child clusters on multiple
providers](https://docs.k0rdent.io/v0.3.0/admin/installation/prepare-mgmt-cluster/?h=providers#prepare-k0rdent-to-create-child-clusters-on-multiple-providers).