---
title: Migrate from MKE 3.x
weight: 4
---

This section instructs you on how to migrate your existing MKE 3.7 cluster to the MKE 4.x version.

## Prerequisites

Verify that you have the following components in place before you begin upgrading MKE 3 to MKE 4:

- An MKE cluster running the latest 3.7.x or 3.8.x release:

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

- The latest `mkectl` binary, installed on your local environment:

  ```shell
  mkectl version
  ```

  Example output:

  ```shell
  Version: v4.0.0-alpha.1.0
  ```

- `k0sctl` version `0.19.0`, installed on your local environment:

  ```shell
  k0sctl version
  ```

  Example output:

  ```shell
  version: v0.19.0
  commit: 9246ddc
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

- A ``calico_kdd`` flag is set to ``true`` in the MKE 3 configuration
  file and applied to the MKE 3 cluster:

  ```yaml
  calico_kdd = true
  ```

- Calico KDD (Kubernetes Datastore Driver), enabled:

  1. Verify that the MKE 3.x instance being upgraded to MKE 4 is running the
     latest 3.7.x or 3.8.x release.

  2. Obtain the MKE 3 configuration file:
 
     ```shell
     $ export MKE_USERNAME=<mke-username>
     $ export MKE_PASSWORD=<mke-password>
     $ export MKE_HOST=<mke-fqdm-or-ip-address>
     $ curl --silent --insecure -X GET "https://$MKE_HOST/api/ucp/config-toml" -H "accept: application/toml" -H "Authorization: Bearer $AUTHTOKEN" > mke-config.toml
     ```

  3. In the `cluster_config` section of the MKE 3 configuration file, set the
     `calico_kdd` parameter to `true`.

  4. Apply the modified MKE 3 configuration file:

     ```shell
     $ AUTHTOKEN=$(curl --silent --insecure --data '{"username":"'$MKE_USERNAME'","password":"'$MKE_PASSWORD'"}' https://$MKE_HOST/auth/login | jq --raw-output .auth_token)
     $ curl --silent --insecure -X PUT -H "accept: application/toml" -H "Authorization: Bearer $AUTHTOKEN" --upload-file 'mke-config.toml' https://$MKE_HOST/api/ucp/config-toml
     {"message":"Calico datastore migration from etcd to kdd successful"}
     ```

{{< callout type="info" >}} The conversion of the Calico datastore from etcd to
KDD typically takes about 20 seconds per node, depending on the size of the cluster. On
completion, the following confirmation displays:

```shell
{"message":"Calico datastore migration from etcd to kdd successful"}
```
{{< /callout >}}

## Migrate configuration

In migrating to MKE 4 from MKE 3, you can directly transfer settings using `mkectl`.

**To convert a local MKE 3 configuration for MKE 4:** set the `--mke3-config` flag
to convert a downloaded MKE 3 configuration file into a valid MKE 4 configuration
file:

```bash
mkectl init --mke3-config </path/to/mke3-config.toml>
```

{{< callout type="info" >}} To upgrade an MKE 3 cluster with GPU enabled,
ensure you complete the [GPU prerequisites](../configuration/nvidia-gpu/#prerequisites) before
starting the upgrade process. {{< /callout >}}

## Perform the migration

An upgrade from MKE 3 to MKE 4 consists of the following steps, all of which
are performed through the use of the `mkectl` tool:

- Run pre-upgrade checks to verify the upgradability of the cluster.
- Carry out pre-upgrade migrations to prepare the cluster for a migration from
  a hyperkube-based MKE 3 cluster to a k0s-based MKE 4 cluster.
- Migrate manager nodes to k0s.
- Migrate worker nodes to k0s.
- Carry out post-upgrade cleanup to remove MKE 3 components.
- Output the new MKE 4 config file.

To upgrade an MKE 3 cluster, use the `mkectl upgrade` command:

```shell
mkectl upgrade --hosts-path <path-to-hosts-yaml> \
  --mke3-admin-username <admin-username> \
  --mke3-admin-password <admin-password> \
  --external-address <external-address>\
  --config-out <path-to-desired-file-location>
```

The external address is the domain name of the load balancer. For details,
see [System requirements: Load balancer requirements](../getting-started/system-requirements#load-balancer-requirements).

The `--config-out` flag allows you to specify a path where the MKE 4 configuration
file will be automatically created and saved during migration. If not specified,
the configuration file prints to your console on completion. In this case, save
the output to a file for future reference

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

## RBAC Migrations

As MKE 4 does not support Swarm mode, the platform uses standard [Kubernetes
RBAC authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).
As such, the Swarm authorization configuration that is in place for MKE 3 is not present in MKE 4.

### Groups

To enable the same RBAC hierarchy as in MKE 3 with `orgs` and `teams` groups, but
without the two-level limitation, MKE 4 replaces `orgs` and `teams` with
the Kubernetes `AggregatedRoles`.

**Authorization structure comparison:**

```
MKE 3:                           MKE 4:

├── entire-company (org)         ├── entire-company-org (AggregatedRole)
│   ├── development (team)       ├── development-team (AggregatedRole)
│   │   ├── bob (user)           │   ├── bob (user)
│   ├── production (team)        ├── production-team (AggregatedRole)
│   │   ├── bob (user)│          │   ├── bob (user)
│   │   ├── bill (user)          │   ├── bill (user)
│   ├── sales (team)             ├── sales-team (AggregatedRole)
```

### Roles

Roles are bound to the aggregated roles for integration into the org, team, and user structure.
Thus, what was previously an organization or a team role will have `-org` or `-team`
appended to its name.

A role can be assigned at any level in the hierarchy, with its permissions granted to all members
at that same level.

**Example organization binding:**

```
├── entire-company-org (AggregatedRole) -- entire-company-org (RoleBinding) -- view (Role)
│   ├── development-team (AggregatedRole)
│   │   ├── bob (user)
│   ├── production-team (AggregatedRole)
│   │   ├── bob (user)
│   │   ├── bill (user)
│   ├── sales-team (AggregatedRole)
```

In the example above, all members of the `entire-company` org group have
`view` permissions. This includes the `development-team`,
`production-team`, `sales-team`, `bob`, and `bill`.

**Example team binding:**

```
│   ├── development:team (AggregatedRole) -- development:team (RoleBinding) -- edit (Role)
│   │   ├── bob (user)
```

In the example above, the binding grants `edit` permissions only to the
members of the development team, which only includes `bob`.

{{< callout type="warning" >}}

Swarm roles are partially translated to Kubernetes roles. During migration,
any detected Swarm role is replicated without permissions, thus
preserving the org/team/user structure.
If no Swarm roles are detected, a `none` role is created as a placeholder,
as Kubernetes requires each aggregated role to have at least one role.
This `none` role has no permissions, with its only purpose being to maintain
structural integrity.

{{< /callout >}}

## CoreDNS Lameduck migration

MKE 4 supports migration from MKE 3 systems that are running with CoreDNS and
Lameduck enabled. Refer
to the table below for a comparison of the CoreDNS Lameduck configuration
parameters between MKE 3 and MKE 4:

| MKE 3                                              | MKE 4                 |
| -------------------------------------------------- | --------------------- |
| [cluster_config.core_dns_lameduck_config.enabled]  | dns.lameduck.enabled  |
| [cluster_config.core_dns_lameduck_config.duration] | dns.lameduck.duration |

## Troubleshoot migration

You can address various potential MKE migration issues using the tips and
suggestions detailed herein.

### MKE 3 ``etcdv3`` backend is unsupported for MKE 4 upgrade

During the upgrade from MKE 3 to MKE 4, which defaults to the ``etcdv3``
backend, you may receive the following error:

```bash
mkectl upgrade --hosts-path hosts.yaml --mke3-admin-username admin --mke3-admin-password <mke_admin_password> -l debug --config-out new-mke4.yaml --external-address <mke4_external_address>
...
Error: unable to generate upgrade config: unsupported configuration for mke4 upgrade: mke3 cluster is using etcdv3 and not kdd backend for calico
```

To resolve the issue, ensure that:

- The MKE 3 source is the latest 3.7.x or 3.8.x release.
- The ``calico_kdd`` flag in the MKE 3 configuration file is set to `true`.
- The configuration is applied to the MKE 3 cluster.

{{< callout type="info" >}}

A KDD mode migration is irreversible. Thus, to reduce risk, when migrating
enterprise clusters, it is recommended that you work directly with Mirantis to
plan the process and monitor it through to completion.

{{< /callout >}}

Example output:

```bash
$ AUTHTOKEN=$(curl --silent --insecure --data '{"username":"'$MKE_USERNAME'","password":"'$MKE_PASSWORD'"}' https://$MKE_HOST/auth/login | jq --raw-output .auth_token)

$ curl --silent --insecure -X PUT -H "accept: application/toml" -H "Authorization: Bearer $AUTHTOKEN" --upload-file 'mke-config.toml' https://$MKE_HOST/api/ucp/config-toml
{"message":"Calico datastore migration from etcd to kdd successful"}
```
