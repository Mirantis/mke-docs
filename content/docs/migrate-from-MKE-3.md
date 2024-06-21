---
title: Migrate from MKE 3.x
weight: 4
---

This section instructs you on how to migrate your existing MKE 3.7 cluster to the MKE 4.x version.

## Prerequisites

Verify that you have the following components in place before you begin upgrading MKE3 to MKE 4:

- A running MKE 3.7.x cluster:

  ```shell
  kubectl get nodes
  ```

  ```shell
  NAME                                           STATUS   ROLES    AGE     VERSION
  ip-172-31-103-202.us-west-2.compute.internal   Ready    master   7m3s    v1.27.7-mirantis-1
  ip-172-31-104-233.us-west-2.compute.internal   Ready    master   7m3s    v1.27.7-mirantis-1
  ip-172-31-191-216.us-west-2.compute.internal   Ready    <none>   6m59s   v1.27.7-mirantis-1
  ip-172-31-199-207.us-west-2.compute.internal   Ready    master   8m4s    v1.27.7-mirantis-1
  ```

- The latest `mkectl` binary, installed on your local enviroment:

  ```shell
  mkectl version
  ```

  Example output:

  ```shell
  Version: v4.0.0-alpha.1.0
  ```

- `k0sctl` version `0.17.4`, installed on your local enviroment:

  ```shell
  k0sctl version
  ```

  Example output:

  ```shell
  version: v0.17.4
  commit: 372a589
  ```

- A `hosts.yaml` file, to provide the information required by `mkectl` to
  connect to each node with SSH.

  Example `hosts.yaml` file:

  ```shell
  cat hosts.yaml
  ```

  ```shell
  hosts:
    - address: <host1-external-ip>
      port: <ssh-port>
      user: <ssh-user>
      keyPath: <path-to-ssh-key>
    - address: <host2-external-ip>
      port: <ssh-port>
      user: <ssh-user>
      keyPath: <path-to-ssh-key>
  ```

## Migrate configuration

In migrating to MKE 4 from MKE 3, you can directly transfer settings using `mkectl`.

**To convert a local MKE 3 configuration for MKE 4:** set the `--mke3-config` flag
to convert a downloaded MKE 3 configuration file into a valid MKE 4 configuration
file:

```bash
mkectl init --mke3-config </path/to/mke3-config.toml>
```

## Perform the migration

An upgrade from MKE 3 to MKE 4 consists of the following steps, all of which
are performed through the use of the `mkectl` tool:

- Run pre-upgrade checks to verify the upgradability of the cluster.
- Carry out pre-upgrade migrations to prepare the cluster for a migration from
  a hyperkube-based MKE 3 cluster to a k0s-based MKE 4 cluster.
- Migrate manager nodes to k0s.
- Migrate worker nodes to k0s.
- Carry out post-upgrade cleanup, to remove MKE 3 components.
- Output the new MKE 4 config file.

To upgrade an MKE 3 cluster, run the following command:

```shell
mkectl upgrade --hosts-path <path-to-hosts-yaml> --admin-username <admin-username> --admin-password <admin-password>
```

{{< callout type="info" >}}

The MKE 4 config file prints to your console when the migration is complete. To
output the config file to a file for future use, run `mkectl apply`.
Alternatively, you can set the `--config-out` flag to the path where you want
to save the MKE 4 config file.

{{< /callout >}}

The upgrade process requires time to complete. Once the process is complete,
run the following command to verify that the MKE 4 cluster is operating:

```shell
sudo k0s kc get nodes
```

Example output:

```shell
NAME                                           STATUS   ROLES    AGE   VERSION
ip-172-31-103-202.us-west-2.compute.internal   Ready    master   29m   v1.29.3+k0s
ip-172-31-104-233.us-west-2.compute.internal   Ready    master   29m   v1.29.3+k0s
ip-172-31-191-216.us-west-2.compute.internal   Ready    <none>   29m   v1.29.3+k0s
ip-172-31-199-207.us-west-2.compute.internal   Ready    master   30m   v1.29.3+k0s
```

{{< callout type="info" >}}

The MKE 3 cluster will no longer be accessible through the previously created
client bundle. The docker swarm cluster will no longer be accessible as well.

{{< /callout >}}

In the event of an upgrade failure, the upgrade process rolls back,
restoring the MKE 3 cluster to its original state.
