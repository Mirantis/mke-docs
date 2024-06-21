---
weight: 1
---

# MKE Architecture

Mirantis Kubernetes Engine (MKE) 4 is an enterprise-grade, production-ready
Kubernetes platform that is designed to be secure, scalable, and reliable.

You can manage the entire MKE 4 cluster through the MKE configuration file.
Refer to [Configuration](configuration) for more information.

## Components

MKE 4 is built on top of k0s, a lightweight Kubernetes distribution.
Refer to the [official k0s documentation](https://docs.k0sproject.io/v1.29.3+k0s.0/)
for more information.

<!-- ### Control plane -->

<!-- [Discuss the control plane component and its function] -->

### Container Network Interface

By default, Calico is installed as the Container Network Interface (CNI) plugin,
with the following configuration:

- IPv4 only, with a fixed Pod CIDR of `10.244.0.0/16`.
- The datastore mode set to `kdd`.
- `kube-proxy` set to `iptables` mode.
- A `vxlan` backend, which uses the default port of `4789` for traffic and default virtual network ID of `4096`.

The MKE 4 Alpha.1 release has the following limitations:

- The CNI plugin cannot be changed.
- Calico cannot be reconfigured.
- The Calico configuration is not migrated during an upgrade to MKE4 from MKE 3.

<!-- ### Data Plane -->

<!-- [Discuss the data plane components and their functions] -->

<!-- ## High-Level Diagram -->

<!-- [Include a high-level diagram illustrating the MKE architecture] -->

<!-- ## Deployment considerations -->

<!-- [Highlight any important considerations for deploying MKE] -->

<!-- ## Conclusion [Wrap up the document with a conclusion or summary] -->

<!-- ### Control plane -->

<!-- [Discuss the control plane component and its function] -->
