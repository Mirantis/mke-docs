---
title: Architecture
weight: 1
---

Mirantis Kubernetes Engine (MKE) 4k is an enterprise-grade, production-ready
Kubernetes platform that is designed to be secure, scalable, and reliable.

You can manage the entire MKE 4k cluster through the mke4.yaml configuration
file. Refer to [Configuration](../configuration) for details.

## Components

MKE 4k is built on top of k0s, a lightweight Kubernetes distribution.
To learn more, refer to [k0s documentation](https://docs.k0sproject.io/v1.29.3+k0s.0/).

<!-- ### Control plane -->

<!-- [Discuss the control plane component and its function] -->

### Networking

By default, Calico is installed as the Container Network Interface (CNI) plugin,
with the following configuration:

- IPv4 only, with a fixed Pod CIDR of `192.168.0.0/16`.
- The datastore mode set to `kdd`.
- `kube-proxy` set to `iptables` mode.
- A `vxlan` backend, which uses the default port of `4789` for traffic and default virtual network ID of `10000`.

Refer to [Container Network Interface](../cni) for the network configuration details

<!-- ### Data Plane -->

<!-- [Discuss the data plane components and their functions] -->

<!-- ## High-Level Diagram -->

<!-- [Include a high-level diagram illustrating the MKE 4k architecture] -->

<!-- ## Deployment considerations -->

<!-- [Highlight any important considerations for deploying MKE 4k] -->

<!-- ## Conclusion [Wrap up the document with a conclusion or summary] -->

<!-- ### Control plane -->

<!-- [Discuss the control plane component and its function] -->
