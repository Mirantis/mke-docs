---
title: Remove a node from an MKE 4 cluster
weight: 5
---

The method for removing nodes from an MKE cluster depends on whether the node is
a control plane node or a worker node.

## Remove a control plane node

Refer to the k0s documentation, [Remove or replace a controller](https://docs.k0sproject.io/stable/remove_controller/)
for information on how to remove a control plane node from an MKE 4 cluster.

## Remove a worker node

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
