---
title: Policy Controller
weight: 7
---

MKE 4k allows installation of third-party policy controllers for Kubernetes.
[OPA Gatekeeper](https://open-policy-agent.github.io/gatekeeper/website/docs/)
is currently the only supported policy controller.

## Configuration

You can configure the Policy Controller through the `policyController`
section of the `mke4.yaml` configuration file.