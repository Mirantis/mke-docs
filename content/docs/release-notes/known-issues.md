---
title: Known issues
weight: 2
---

The MKE 4 known issues with available workarounds are described herein.

## [BOP-583] LDAP settings fail to migrate during upgrade from MKE 3

LDAP configurations are not stored in MKE 3 configuration files, and thus they
are not included when you upgrade to MKE 4 from an MKE 3 installation.

**Workaround:**

When upgrading from MKE 3, you must manually add the LDAP configuration.

1. Make a request to ``https://{{host}}/enzi/v0/config/auth/ldap`` on the MKE 3
cluster prior to the migration. For more information, refer to the [MKE 3
LDAP Configuration through API documentation](https://docs.mirantis.com/mke/3.7/ops/administer-cluster/integrate-with-LDAP-directory/configure-ldap-integration.html#ldap-configuration-through-api).

2. Convert the LDAP response to the MKE 4 LDAP settings.
3. Apply the translated LDAP settings to the cluster following migration.

## [BOP-708] OIDC authentication fails after mkectl upgrade

Due to an issue with client secret migration, OIDC authentication fails
following an upgrade performed with `mkectl`.

**Workaround:**

1. Copy the MKE 4 configuration that prints at the end of migration.

2. Update the `authentication.oidc.clientSecret` field to the secret field
   from your identity provider.

3. Apply the updated MKE 4 configuration.

## [BOP-898][BOP-899] Calico eBPF and IPVS modes are not supported

Calico eBPF and IPVS mode are not yet supported for MKE 4. As such, upgrading
from an MKE 3 cluster using either of those networking modes results in an
error:

```sh
FATA[0640] Upgrade failed due to error: failed to run step [Upgrade Tasks]: unable to install BOP: unable to apply MKE4 config: failed to wait for pods: failed to wait for pods: failed to list pods: client rate limiter Wait returned an error: context deadline exceeded
```

## [BOP-905] Prometheus dashboard reports incorrect heavy memory use

The Prometheus dashboard displays heavy memory use that does not accurately
reflect true memory status.

## [BOP-947] Managed user passwords are not migrated during upgrade from MKE 3

The `admin` password is migrated during upgrade from MKE 3, however all other
managed user passwords are not migrated.

## [BOP-964] mke-operator in crashloopbackoff status

The mke-operator-controller-manager is in crashloopbackoff status in MKE 4
Alpha 2. You can safely ignore this, however, as it has no effect on MKE
4.0.0-alpha.2.0 functionality.

## [BOP-982] Cannot change MKE 4 password using mkectl

You cannot change the password for an existing MKE 4 deployment by running
``mkectl apply -f mke4.yaml --admin-password <password>``, which is the
expected behavior.

**Workaround:**

Use ``kubectl`` to change the ``Password`` object:

1. Obtain the list of users:

   ```sh
   $ kubectl -n mke get passwords -o custom-columns=NAME:.metadata.name,EMAIL:.email
   ```

   Example output:

   ```sh
   NAME                    EMAIL
   mfsg22lozpzjzzeeeirsk   admin
2. Reveal the Password object for the target user.

   ```sh
   $ % km get password mfsg22lozpzjzzeeeirsk -oyaml
   ```

   Example output:

   ```sh
   apiVersion: dex.coreos.com/v1
   email: admin
   hash: JDJhJDEwJFA5RUppWmVJLkRCMVlqMWJqZk5rUk9RQ1oybFFpOUhXUFhnYmIxdUFPSkpHeGFDWUl1OTcy
   kind: Password
   metadata:
     creationTimestamp: "2024-07-23T18:39:11Z"
     generation: 1
     name: mfsg22lozpzjzzeeeirsk
     namespace: mke
     resourceVersion: "3558"
     uid: 91a9e728-abfa-4daa-bdab-4c09cf888281
   userID: 7668fdb9-a979-4645-b6cc-10985df77da6
   username: admin
3. Edit the ``hash`` field with the desired password hash.

## [BOP-1299] Disk Usage and Memory metrics are not shown correctly in the dashboard with disabled cAdvisor

When cAdvisor is disabled, the main page of the dashboard presents 0% as the value for the **Disk Usage** and **Memory** metrics.

**Workaround:**

Enable cAdvisor in the MKE configuration file and run `mkectl apply`.

```yaml
monitoring:
  enableCAdvisor: true
```

## [BOP-1299] Max Used Disk and Max CPU labels are swapped in the MKE dashboard

No workaround is available at this time.

## [BOP-1307] Prometheus can be accessed without authentication

Any party with knowledge of the MKE 4 URL can access Prometheus without authentication.

No workaround is available at this time.
