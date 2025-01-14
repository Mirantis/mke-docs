---
title: etcd
weight: 6
---

etcd is a consistent, distributed key-value store that provides a reliable way to store data that needs to be accessed by a distributed system or cluster of machines. It handles leader elections during network partitions and can tolerate machine failure, even in the leader node.

For MKE, etcd serves as the Kubernetes backing store for all cluster data, with an etcd replica deployed on each MKE manager node. This is a primary reason why Mirantis recommends that you deploy an odd number of MKE manager nodes, as etcd uses the Raft consensus algorithm and thus requires that a quorum of nodes agrees on any updates to the cluster state.

For detailed information, refer to the official [etcd documentation](https://etcd.io/docs/).

## Configure etcd

You can configure etcd through the `etcd` section of the MKE configuration file, an example of which follows:

```yaml
spec:
  etcd:
    storageQuota: 2GB
    tlsCipherSuites: TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256
```

## Configure etcd storage quota

You can control the etcd distributed key-value storage quota using the `etcd.storageQuota` parameter in the MKE configuration file. By default, the value of the parameter is 2GB.

If you choose to increase the etcd quota, be aware that this quota has a limit and such action should be used in conjunction with other strategies, such as decreasing events TTL to ensure that the etcd database does not run out of space.

{{< callout type="warning" >}} If a manager node virtual machine runs out of disk space, or if all of its system memory is depleted, etcd can cause the MKE cluster to move into an irrecoverable state. To prevent this from happening, configure the disk space and the memory of the manager node VMs to levels that are well in excess of the set etcd storage quota. {{< /callout >}}

{{< callout type="info" >}}

For additional information, refer to the etcd official documentation, [How to debug large db size issue?](https://etcd.io/blog/2023/how_to_debug_large_db_size_issue/)

{{< /callout >}}
