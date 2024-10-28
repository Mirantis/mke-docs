---
title: Node Feature Discovery (NFD)
weight: 8
---

Node Feature Discovery (NFD) software detects the hardware features that are
available on each node in a Kubernetes cluster, and advertises the detected
features through node labels. NFD shares this information with
[kube-scheduler](../kubernetes/kube-scheduler), which uses the information
in its work.

## Configuration

MKE 4 supports the deployment of NFD as an add-on. Enabled by default, the NFD
add-on deploys as a helm chart, version `0.16.1` in the `mke` namespace.

{{< callout type="info" >}} The MKE 4 configuration file does not expose
parameters for the NFD add-on. {{< /callout >}}

1. Obtain the default configuration file:

   ```bash
   mkectl init
   ```

2. Apply the configuration:

   ```bash
   mkectl apply -f [config-file]
   ```

3. Verify the successful deployment of NFD in the cluster:

   ```bash
   kubectl get pods,services,deployments -n mke -l app.kubernetes.io/name=node-feature-discovery
   ```

   Sample output:

   ```bash
   NAME                                                 READY   STATUS    RESTARTS   AGE
   pod/node-feature-discovery-gc-5477c88f99-dltjp       1/1     Running   0          24h
   pod/node-feature-discovery-master-665757d679-g8kt9   1/1     Running   0          24h
   pod/node-feature-discovery-worker-vv28z              1/1     Running   0          24h
   pod/node-feature-discovery-worker-zlb5s              1/1     Running   0          24h

   NAME                                            READY   UP-TO-DATE   AVAILABLE   AGE
   deployment.apps/node-feature-discovery-gc       1/1     1            1           24h
   deployment.apps/node-feature-discovery-master   1/1     1            1           24h
   ```

4. Verify the labels on the nodes:

   ```bash
   kubectl get nodes -o json | jq '.items[].metadata.labels'
   ```

   Sample output:

   ```bash
   {
   "beta.kubernetes.io/arch": "amd64",
   "beta.kubernetes.io/os": "linux",
   "feature.node.kubernetes.io/cpu-cpuid.ADX": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AESNI": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AVX": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AVX2": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AVX512BW": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AVX512CD": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AVX512DQ": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AVX512F": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AVX512VL": "true",
   "feature.node.kubernetes.io/cpu-cpuid.CMPXCHG8": "true",
   "feature.node.kubernetes.io/cpu-cpuid.FMA3": "true",
   "feature.node.kubernetes.io/cpu-cpuid.FXSR": "true",
   "feature.node.kubernetes.io/cpu-cpuid.FXSROPT": "true",
   "feature.node.kubernetes.io/cpu-cpuid.HYPERVISOR": "true",
   "feature.node.kubernetes.io/cpu-cpuid.LAHF": "true",
   "feature.node.kubernetes.io/cpu-cpuid.MOVBE": "true",
   "feature.node.kubernetes.io/cpu-cpuid.MPX": "true",
   "feature.node.kubernetes.io/cpu-cpuid.OSXSAVE": "true",
   "feature.node.kubernetes.io/cpu-cpuid.SYSCALL": "true",
   "feature.node.kubernetes.io/cpu-cpuid.SYSEE": "true",
   "feature.node.kubernetes.io/cpu-cpuid.X87": "true",
   "feature.node.kubernetes.io/cpu-cpuid.XGETBV1": "true",
   "feature.node.kubernetes.io/cpu-cpuid.XSAVE": "true",
   "feature.node.kubernetes.io/cpu-cpuid.XSAVEC": "true",
   "feature.node.kubernetes.io/cpu-cpuid.XSAVEOPT": "true",
   "feature.node.kubernetes.io/cpu-cpuid.XSAVES": "true",
   "feature.node.kubernetes.io/cpu-hardware_multithreading": "true",
   "feature.node.kubernetes.io/cpu-model.family": "6",
   "feature.node.kubernetes.io/cpu-model.id": "85",
   "feature.node.kubernetes.io/cpu-model.vendor_id": "Intel",
   "feature.node.kubernetes.io/kernel-config.NO_HZ": "true",
   "feature.node.kubernetes.io/kernel-config.NO_HZ_IDLE": "true",
   "feature.node.kubernetes.io/kernel-version.full": "5.15.0-1070-aws",
   "feature.node.kubernetes.io/kernel-version.major": "5",
   "feature.node.kubernetes.io/kernel-version.minor": "15",
   "feature.node.kubernetes.io/kernel-version.revision": "0",
   "feature.node.kubernetes.io/memory-swap": "true",
   "feature.node.kubernetes.io/pci-0300_1d0f.present": "true",
   "feature.node.kubernetes.io/storage-nonrotationaldisk": "true",
   "feature.node.kubernetes.io/system-os_release.ID": "ubuntu",
   "feature.node.kubernetes.io/system-os_release.VERSION_ID": "20.04",
   "feature.node.kubernetes.io/system-os_release.VERSION_ID.major": "20",
   "feature.node.kubernetes.io/system-os_release.VERSION_ID.minor": "04",
   "kubernetes.io/arch": "amd64",
   "kubernetes.io/hostname": "ip-172-31-87-104.us-west-2.compute.internal",
   "kubernetes.io/os": "linux",
   "node-role.kubernetes.io/control-plane": "true",
   "node.k0sproject.io/role": "control-plane"
   }
   {
   "beta.kubernetes.io/arch": "amd64",
   "beta.kubernetes.io/os": "linux",
   "feature.node.kubernetes.io/cpu-cpuid.ADX": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AESNI": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AVX": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AVX2": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AVX512BW": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AVX512CD": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AVX512DQ": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AVX512F": "true",
   "feature.node.kubernetes.io/cpu-cpuid.AVX512VL": "true",
   "feature.node.kubernetes.io/cpu-cpuid.CMPXCHG8": "true",
   "feature.node.kubernetes.io/cpu-cpuid.FMA3": "true",
   "feature.node.kubernetes.io/cpu-cpuid.FXSR": "true",
   "feature.node.kubernetes.io/cpu-cpuid.FXSROPT": "true",
   "feature.node.kubernetes.io/cpu-cpuid.HYPERVISOR": "true",
   "feature.node.kubernetes.io/cpu-cpuid.LAHF": "true",
   "feature.node.kubernetes.io/cpu-cpuid.MOVBE": "true",
   "feature.node.kubernetes.io/cpu-cpuid.MPX": "true",
   "feature.node.kubernetes.io/cpu-cpuid.OSXSAVE": "true",
   "feature.node.kubernetes.io/cpu-cpuid.SYSCALL": "true",
   "feature.node.kubernetes.io/cpu-cpuid.SYSEE": "true",
   "feature.node.kubernetes.io/cpu-cpuid.X87": "true",
   "feature.node.kubernetes.io/cpu-cpuid.XGETBV1": "true",
   "feature.node.kubernetes.io/cpu-cpuid.XSAVE": "true",
   "feature.node.kubernetes.io/cpu-cpuid.XSAVEC": "true",
   "feature.node.kubernetes.io/cpu-cpuid.XSAVEOPT": "true",
   "feature.node.kubernetes.io/cpu-cpuid.XSAVES": "true",
   "feature.node.kubernetes.io/cpu-hardware_multithreading": "true",
   "feature.node.kubernetes.io/cpu-model.family": "6",
   "feature.node.kubernetes.io/cpu-model.id": "85",
   "feature.node.kubernetes.io/cpu-model.vendor_id": "Intel",
   "feature.node.kubernetes.io/kernel-config.NO_HZ": "true",
   "feature.node.kubernetes.io/kernel-config.NO_HZ_IDLE": "true",
   "feature.node.kubernetes.io/kernel-version.full": "5.15.0-1070-aws",
   "feature.node.kubernetes.io/kernel-version.major": "5",
   "feature.node.kubernetes.io/kernel-version.minor": "15",
   "feature.node.kubernetes.io/kernel-version.revision": "0",
   "feature.node.kubernetes.io/memory-swap": "true",
   "feature.node.kubernetes.io/pci-0300_1d0f.present": "true",
   "feature.node.kubernetes.io/storage-nonrotationaldisk": "true",
   "feature.node.kubernetes.io/system-os_release.ID": "ubuntu",
   "feature.node.kubernetes.io/system-os_release.VERSION_ID": "20.04",
   "feature.node.kubernetes.io/system-os_release.VERSION_ID.major": "20",
   "feature.node.kubernetes.io/system-os_release.VERSION_ID.minor": "04",
   "kubernetes.io/arch": "amd64",
   "kubernetes.io/hostname": "ip-172-31-87-179.us-west-2.compute.internal",
   "kubernetes.io/os": "linux"
   ```