---
title: Adding and removing cluster nodes
weight: 5
---

## Add a node to an MKE 4 cluster

1. Make sure you have the host information for the new node on hand. You will
   plug this information into the MKE configuration file in the following
   format:

   ```
   ...
   hosts:
       ...
       - role: worker
         ssh:
           address: <address>
           keyPath: <key location
           port: <ssh port>
           user: <username>
   ...
   ```

2. Obtain the MKE configuration file from your cluster:

   ```
   mkectl config get
   ```

3. Update the `mke4.yaml` file with the host information for the new node.

4. Run `mkectl apply` command to add the new node.

## Remove a node from an MKE 4 cluster

The method for removing nodes from an MKE cluster difers, depending on whether
the node is a control plane node or a worker node.

### Remove a control plane node

Refer to the k0s documentation, [Remove or replace a controller](https://docs.k0sproject.io/stable/remove_controller/)
for information on how to remove a control plane node from an MKE 4 cluster.

### Remove a worker node

1. Delete the worker node from the cluster:

   ```bash
   kubectl --kubeconfig ~/.mke/mke.kubeconf delete node <worker_node_name>
   ```

2. Run the following command sequence on the node itself:

   ```bash
   k0s stop
   k0s reset
   reboot
   ```
