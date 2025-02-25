---
title: Add SANs to cluster certificates
weight: 10
---

A SAN (Subject Alternative Name) is a structured means for associating various
values (such as domain names, IP addresses, email addresses, URIs, and so on)
with a security certificate.

MKE always runs with HTTPS enabled. As such, whenever you connect to MKE, you
must ensure that the MKE certificates recognize the host name in use.
For example, if MKE is behind a load balancer that forwards traffic to your
MKE instance, your requests will not be for the MKE host name or IP address
but for the host name of the load balancer. Thus, MKE will reject the requests
unless you include the address of the load balancer as a SAN in
the MKE certificates.

{{< callout type="info" >}}
- Mirantis does not currently support adding SANs to MKE web UI TLS certificates.
  The only way to specify a desired list of SANs is to issue your
  own TLS certificate for the Ingress controller and use it as described in
  [TLS certificates](tls-certificates.md).
- To use your own TLS certificates, confirm first that these certificates have 
  the correct SAN values.
- To use the self-signed certificate that MKE offers out-of-the-box, you can
  use the `--san` argument to set up the SANs during MKE deployment.
{{< /callout >}}

**To add new SANs using the Kubernetes API server serving certificate:**

Herein procedure only updates the SANs of the Kubernetes API server.

1. To append SANs to the Kube API server, add them to the configuration file:

   ```yaml
   spec:
     apiServer:
       sans:
       - san1.com
       - san2.com
    ```
2. Apply configuration by running `mkectl`.


