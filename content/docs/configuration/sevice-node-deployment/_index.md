---
title: Service node deployment
weight: 7
---

You can configure MKE to allow users to deploy and run services in worker
nodes only, to ensure that all cluster management functionality remains
performant and to enhance cluster security.

{{< callout type="warning" >}}

If for whatever reason a user deploys a malicious service that can affect
the node on which it is running, that service will not be able to strike any
other nodes in the cluster or have any impact on cluster management
functionality.

{{< /callout >}}