---
title: Prepare KubeVirt deployment
weight: 2
---

To deploy KubeVirt, the KVM kernel module must be present on all Kubernetes
nodes on which virtual machines will run, and nested virtualization must be
enabled in all virtual environments.

Run the following local platform validation on your Kubernetes nodes to
determine whether they can be used for KubeVirt:

```bash
lsmod | grep -i kvm
cat /sys/module/kvm_intel/parameters/nested
```

Example output:

```bash
lsmod | grep -i kvm
kvm_intel             483328  0
kvm                  1396736  1 kvm_intel
```

If the validation routine does not return results that resemble those
presented in the example output, the node cannot be used for KubeVirt.
