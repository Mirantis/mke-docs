---
title: System requirements
weight: 1
---

Before you start cluster deployment, verify that your system meets the following minimum hardware
and software requirements.

## Hardware requirements

MKE uses [k0s](https://k0sproject.io/) as the underlying Kubernetes
distribution. To learn the k0s hardware requirements, refer to the [k0s
documentation](https://docs.k0sproject.io/v1.29.4+k0s.0/system-requirements/).

## Software requirements

- Operating systems:
  - Ubuntu 22.04 Linux
  - RHEL 8.10
  - Rocky Linux 9.4
- Architecture: `amd64`
- CNI: Calico

## Load balancer requirements

The load balancer can be implemented in many different ways. You can use for example
HAProxy, NGINX, or the load balancer of your cloud provider.

To ensure the MKE Dashboard functions properly, MKE requires a TCP load balancer.
This load balancer acts as a single point of contact to access the controllers.
With the default MKE configuration, the load balancer must allow and route traffic
to each controller through the following ports:

| Listen port | Target port | Purpose             | Configurable         |
| ----------- | ----------- | ------------------- | -------------------- |
| 6443        | 6443        | Kubernetes API      | {{< icon "ban" >}}   |
| 8132        | 8132        | Konnectivity        | {{< icon "ban" >}}   |
| 9443        | 9443        | Controller join API | {{< icon "ban" >}}   |
| 443         | 33001       | Ingress Controller  | {{< icon "check" >}} |

You can configure the listen port of the Ingress Controller to be different from
the default port `443`. However, if you change the listen port, you must append
the new port number to the external address in the configuration file. For example,
if you set the listen port to be the same as the target port, `33001`, the configuration
should look as follows:

```yaml
apiServer:
  externalAddress: "mke.example.com:33001"
```

The target port must match the HTTPS node port of the Ingress Controller,
which is `33001` by default, but can be adjusted as needed. See the configuration
details for `nodePorts` in the 
[Ingress Controller configuration](../../configuration/ingress#configuration).
