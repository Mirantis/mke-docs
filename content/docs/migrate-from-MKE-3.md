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

### Migration failure

In the event of an upgrade failure, the upgrade process rolls back,
restoring the MKE 3 cluster to its original state.

Example output:

```shell
WARN[0096] Initiating rollback because of upgrade failure. upgradeErr = aborting upgrade due to signal interrupt 
INFO[0096] Initiating rollback of MKE to version: 3.7.15 
INFO[0096] Step 1 of 2: [Rollback Upgrade Tasks]        
INFO[0096] Resetting k0s using k0sctl ...               
INFO[0106] ==> Running phase: Connect to hosts          
INFO[0106] [ssh] 54.151.30.20:22: connected             
INFO[0106] [ssh] 54.215.145.126:22: connected           
INFO[0106] ==> Running phase: Detect host operating systems 
INFO[0106] [ssh] 54.151.30.20:22: is running Ubuntu 22.04.5 LTS 
INFO[0106] [ssh] 54.215.145.126:22: is running Ubuntu 22.04.5 LTS 
INFO[0106] ==> Running phase: Acquire exclusive host lock 
INFO[0107] ==> Running phase: Prepare hosts             
INFO[0107] ==> Running phase: Gather host facts         
INFO[0107] [ssh] 54.151.30.20:22: using ip-172-31-8-69.us-west-1.compute.internal as hostname 
INFO[0107] [ssh] 54.215.145.126:22: using ip-172-31-48-46.us-west-1.compute.internal as hostname 
INFO[0107] [ssh] 54.151.30.20:22: discovered ens5 as private interface 
INFO[0107] [ssh] 54.215.145.126:22: discovered ens5 as private interface 
INFO[0107] [ssh] 54.151.30.20:22: discovered 172.31.8.69 as private address 
INFO[0107] [ssh] 54.215.145.126:22: discovered 172.31.48.46 as private address 
INFO[0107] ==> Running phase: Gather k0s facts          
INFO[0108] [ssh] 54.215.145.126:22: found existing configuration 
INFO[0108] [ssh] 54.215.145.126:22: is running k0s controller+worker version v1.31.1+k0s.1 
WARN[0108] [ssh] 54.215.145.126:22: the controller+worker node will not schedule regular workloads without toleration for node-role.kubernetes.io/master:NoSchedule unless 'noTaints: true' is set 
INFO[0108] [ssh] 54.215.145.126:22: listing etcd members 
INFO[0110] [ssh] 54.151.30.20:22: is running k0s worker version v1.31.1+k0s.1 
INFO[0110] [ssh] 54.215.145.126:22: checking if worker ip-172-31-8-69.us-west-1.compute.internal has joined 
INFO[0110] ==> Running phase: Reset workers             
INFO[0111] [ssh] 54.151.30.20:22: reset                 
INFO[0111] ==> Running phase: Reset controllers         
INFO[0114] [ssh] 54.215.145.126:22: reset               
INFO[0114] ==> Running phase: Reset leader              
INFO[0114] [ssh] 54.215.145.126:22: reset               
INFO[0114] ==> Running phase: Reload service manager    
INFO[0114] [ssh] 54.151.30.20:22: reloading service manager 
INFO[0114] [ssh] 54.215.145.126:22: reloading service manager 
INFO[0115] ==> Running phase: Release exclusive host lock 
INFO[0115] ==> Running phase: Disconnect from hosts     
INFO[0115] ==> Finished in 8s                           
INFO[0125] Running etcd cleanup service ...             
INFO[0128] MKE3 etcd directories successfully cleaned up ... 
INFO[0128] Restoring etcd from the previously taken system backup ... 
INFO[0128] Successfully restored etcd with output:      
INFO[0128] Deploying etcd server ...                    
INFO[0129] Successfully deployed the etcd server with output: fb09c3e5e514d9ffe03a3df4bc461c29a695cf73d703ace5294702b7023021af 
INFO[0129] Waiting for etcd to be healthy ...           
INFO[0131] etcd health check succeeded!                 
INFO[0178] [Rollback Upgrade Tasks] Completed           
INFO[0178] Step 2 of 2: [Rollback Pre Upgrade Tasks]    
INFO[0178] [Rollback Pre Upgrade Tasks] Completed       
INFO[0178] Rollback to MKE version 3.7.15 completed successfully ... 
FATA[0178] Upgrade failed due to error: aborting upgrade due to signal interrupt 
```

## Revert the migration

To revert a cluster upgraded to MKE 4 back to MKE 3:

1. [Uninstall MKE 4](../getting-started/uninstall-cluster).

2. [Restore MKE 3 from a backup](https://docs.mirantis.com/mke/current/ops/disaster-recovery.html).


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
