---
title: Deploy Kubevirt
weight: 4
---

You can deploy Kubevirt using manifest files that are available from the
Mirantis Azure CDN:

* https://binary-mirantis-com.s3.amazonaws.com/kubevirt/hyperconverged-cluster-operator/hco-operator-20240912172342.yaml

* https://binary-mirantis-com.s3.amazonaws.com/kubevirt/hyperconverged-cluster-operator/hco-cr-20240912172342.yaml

Run the following command to check KubeVirt readiness:

```bash
kubectl wait -n kubevirt-hyperconverged kv kubevirt-kubevirt-hyperconverged
--for condition=Available --timeout 5m
```

Example output:

```bash
kubevirt.kubevirt.io/kubevirt-kubevirt-hyperconverged condition met
```
