---
title: Create a cluster
weight: 3
---

{{< callout type="info" >}}

For information on how to create a cluster in an airgapped environment, refer to [Offline installation](../offline-installation).

{{< /callout >}}

## Install dependecies

Verify that you have installed `mkectl` and other dependencies on your system
as described in [Install MKE 4k CLI](../install-mke-4k-cli).

## Configure cluster nodes

Configure the cluster nodes in advance, in accordance with the [System
requirements](../system-requirements).

Node provisioning is managed by the cluster administrators. You can, for
instance, use Terraform to create the nodes in a cloud provider.
Refer to [Example Terraform configuration](../../tutorials/k0s-in-aws/terraform-scenario)
for an example.

## Initialize deployment

MKE 4k streamlines the cluster deployment through the use of a single YAML file, which
details the desired cluster configuration. This approach simplifies the setup
process and ensures consistency in cluster deployments.

1. Generate the YAML file for your installation:

   ```shell
   mkectl init > mke4.yaml
   ```

2. In the generated configuration file:

   - Edit the `hosts` section to match your roster of nodes. Provide the SSH
     information for each cluster node, as well as the role of the node based
     on their functions within the cluster. The table below provides the list
     of available node roles and their descriptions:

     | Node Role             | Description                                                                                     |
     |-----------------------|-------------------------------------------------------------------------------------------------|
     | **controller+worker** | A manager node that runs both control plane and data plane components. This role combines the responsibilities of managing cluster operations and executing workloads. |
     | **worker**            | A worker node that runs the data plane components. These nodes are dedicated to executing workloads and   handling the operational tasks assigned by the control plane. |
     | **single**            | A special role used when the cluster consists of a single node. This node handles both control plane and data plane components, effectively managing and executing workloads within a standalone environment. |

   - Specify the external address in the in `apiServer.externalAddress` field.
     The external address is the domain name of the load balancer configured
     as described in [System Requirements: Load balancer](../system-requirements#load-balancer-requirements).

{{< callout type="important" >}}
You may need to add the SSH private key to your identity manager in order for mkectl to connect to it.
- With ssh-agent:
  ```
  ssh-add <path_to_your_SSH_private_key>
  ```
- Without ssh-agent, ensure that the SSH private key is accessible at the path specified in the keyPath field of the mke4.yaml configuration file.
{{< /callout >}}

## Create a cluster

{{< callout type="warning" >}}

Before you create a new MKE 4k cluster you must first verify that a cluster does
not already exist in the system. If you attempt to create a cluster where a
cluster is already present, even through the use of a different configuration
file, you will lose the ability to use `mkectl` to access the original cluster.

For information on how to delete a cluster, refer to [Uninstall a
cluster](../uninstall-cluster).

{{< /callout >}}

To create a new cluster, run the `mkectl apply` command with the generated YAML
configuration file:

```shell
mkectl apply -f mke4.yaml
```

{{< callout type="info" >}}

The `mkectl apply` command configures the `mke` context in the default
kubeconfig file located at `~/.kube/config`. If the default kubeconfig is
changed, and the `mke` context becomes invalid or unavailable, `mkectl` will
not be able to manage the cluster until the kubeconfig is restored.

{{< /callout >}}

Once the new cluster is viable, you can start interacting with it using
`kubectl` with the `mke` context.