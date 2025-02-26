---
title: Add and remove cluster nodes
weight: 5
---

{{< callout type="info" >}}

To avoid unexpected complications, make sure that you have an MKE 4 cluster
up and running before you follow the procedures herein for adding and
removing nodes.

{{< /callout >}}

## Add nodes to an MKE 4 cluster

1. [Obtain the MKE configuration file for your cluster](../get-current-mke-config).

2. Append the host information for the new node to the `hosts` section of the
   MKE configuration file in the following format:

   ```
   - role: worker
     ssh:
       address: <address>
       keyPath: <key location>
       port: <ssh port>
       user: <username>
   ```

3. Run `mkectl apply` command to add the new node.

## Remove nodes from an MKE 4 cluster

The method for removing nodes from an MKE cluster differs, depending on whether
the node is a control plane node or a worker node.

### Remove a control plane node

Refer to the k0s documentation, [Remove or replace a
controller](https://docs.k0sproject.io/stable/remove_controller/) for
information on how to remove a control plane node from an MKE 4 cluster.

### Remove a worker node

1. Delete the worker node from the cluster:

   ```bash
   kubectl --kubeconfig ~/.mke/mke.kubeconf delete node <worker_node_name>
   ```

2. Run the following command sequence on the node itself, to uninstall
   k0s:

   ```bash
   k0s stop
   k0s reset
   reboot
   ```

3. [Obtain the MKE configuration file for your cluster](../get-current-mke-config).

4. Delete the host information for the deleted node from the `hosts` section
   of the MKE configuration file, to circumvent any potential mkectl issues.

5. Apply the configuration:

   ```
   mkectl apply -f <mke-configuration-file>
   ```
