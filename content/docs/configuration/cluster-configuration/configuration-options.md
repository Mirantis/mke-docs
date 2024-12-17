---
title: Configuration options
weight: 2
---

## auth table

| Parameter                | RQD | Description                                                                                                                                                                           |
|--------------------------|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `backend`                | no       | The name of the authorization backend to use, `managed` or `ldap`.  <br><br>Default: `managed`                                                                                                |
| `default_new_user_role` | no       | The role assigned to new users for their private resource sets.  <br><br>Valid values: `admin`, `viewonly`, `scheduler`, `restrictedcontrol`, or `fullcontrol`.  <br><br>Default: `restrictedcontrol` |

## auth.sessions

| Parameter                    | RQD | Description                                                                                                                                                                                                                                 |
|------------------------------|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `lifetime_minutes`          | no       | The initial session lifetime, in minutes.  <br><br>Default: `60`                                                                                                                                                                                    |
| `renewal_threshold_minutes` | no       | The length of time, in minutes, before the expiration of a session where, if used, a session will be extended by the current configured lifetime from then. A value of `0` disables session extension.  <br><br>Default: `20`                       |
| ` per_user_limit`            | no       | The maximum number of sessions that a user can have simultaneously active. If creating a new session will put a user over this limit, the least recently used session is deleted.  A value of `0` disables session limiting.  <br><br>Default: `10` |
| `store_token_per_session`   | no       | If set, the user token is stored in `sessionStorage` instead of `localStorage`. Setting this option logs the user out and requires that they log back in, as they are actively changing the manner in which their authentication is stored. |

## auth.external_identity_provider (optional) {#auth-external-identity-provider}

Configures MKE with an external OpenID Connect (OIDC) identity provider.

| Parameter            | RQD          | Description                                                                                                                                                                                                       |
|----------------------|--------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `wellKnownConfigUrl` | yes                | Sets the OpenID discovery endpoint, ending in `.well-known/openid-configuration`, for your identity provider.                                                                                                     |
| `clientID`           | yes                | Sets the client ID, which you obtain from your identity provider.                                                                                                                                                 |
| `clientSecret`       | no (recommended) | Sets the client secret, which you obtain from your identity provider.                                                                                                                                             |
| `usernameClaim`      | no                 | Sets the unique JWT ID token claim that contains the user names from your identity provider.  <br><br>Default: `sub`                                                                                                      |
| `caBundle`           | no                 | Sets the PEM certificate bundle that MKE uses to authenticate the discovery, issuer, and JWKs endpoints.                                                                                                          |
| `httpProxy`          | no                 | Sets the HTTP proxy for your identity provider.                                                                                                                                                                   |
| `httpsProxy`         | no                 | Sets the HTTPS proxy for your identity provider.                                                                                                                                                                  |
| `issuer`             | no                 | Sets the ID token issuer. If left blank, the value is obtained automatically from the discovery endpoint.                                                                                                         |
| `userServiceId`      | no                 | Sets the MKE service ID with the JWK URI for the identity provider. If left blank, the service ID is generated automatically.  ::: warning ::: title Warning :::  Do not remove or replace an existing value. ::: |

## auth.external_identity_provider.signInCriteria array (optional)

An array of claims that ID tokens require for use with MKE.

| Parameter   | RQD | Description                                                                                                                                                                                                                    |
|-------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `term`      | yes      | Sets the name of the claim.                                                                                                                                                                                                    |
| `value`     | yes      | Sets the value for the claim in the form of a string.                                                                                                                                                                          |
| `matchType` | yes      | Sets how MKE evaluates the JWT claim.  <br><br>Valid values:  <br>* `must`: JWT claim value must be the same as the configuration value. <br>* `contains`: JWT claim value must contain the configuration value. |

## auth.external_identity_provider.adminRoleCriteria array (optional)

An array of claims that admin user ID tokens require for use with MKE.
Creating a new account using a token that satisfies the criteria
determined by this array automatically produces an administrator
account.

| Parameter   | REQD | Description                                                                                                                                                                                                      |
|-------------|-----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `term`      | yes       | Sets the name of the claim.                                                                                                                                                                                      |
| `value`     | yes       | Sets the value for the claim in the form of a string.                                                                                                                                                            |
| `matchType` | yes       | Sets how the JWT claim is evaluated. <br><br> Valid values: <br> * `must`: JWT claim value must be the same as the configuration value. <br> * `contains`: JWT claim value must contain the configuration value. |


## auth.account_lock (optional)

| Parameter         | REQD | Description                                                                                                                                          |
|-------------------|------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| `enabled`         | no   | Sets whether the MKE account lockout feature is enabled.                                                                                             |
|  `failureTrigger` | no   | Sets the number of failed log in attempts that can occur before an account is locked.                                                                |
| `durationSeconds` | no   | Sets the desired lockout duration in seconds. A value of `0` indicates that the account will remain locked until it is unlocked by an administrator. |

## hardening_configuration (optional)

The `hardening_enabled` option must be set to `true` to enable all other
`hardening_configuration` options.

| Parameter                    | REQD | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
|------------------------------|-----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `hardening_enabled`          | no        | Parent option that when set to `true` enables security hardening configuration options: `limit_kernel_capabilities`, `pid_limit`, `pid_limit_unspecified`, and `use_strong_tls_ciphers`.  <br><br>Default: `false`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `limit_kernel_capabilities` | no        | **The option can only be enabled when** `hardening_enabled` **is set to** `true`.  <br><br>Limits kernel capabilities to the minimum required by each container.  Components run using Docker default capabilities by default. When you enable `limit_kernel_capabilities` all capabilities are dropped, except those that are specifically in use by the component. Several components run as privileged, with capabilities that cannot be disabled.  <br><br>Default: `false`                                                                                                                                                                                                                                                                                                              |
| `pid_limit`                  | no        | **The option can only be enabled when** `hardening_enabled` **is set to** `true`.  <br><br>Sets the maximum number of PIDs MKE can allow for their respective orchestrators.  The `pid_limit` option must be set to the default `0` when it is not in use.  <br><br>Default: `0`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `pid_limit_unspecified`     | no        | **The option can only be enabled when** `hardening_enabled` **is set to** `true`.  <br><br>When set to `false`, enables PID limiting, using the `pid_limit` option value for the associated orchestrator.  <br><br>Default: `true`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `use_strong_tls_ciphers`    | no        | **The option can only be enabled when** `hardening_enabled` **is set to** `true`.  <br><br>When set to `true`, in line with control 4.2.12 of the CIS Kubernetes Benchmark 1.7.0, the `use_strong_tls_ciphers` parameter limits the allowed ciphers for the `cipher_suites_for_kube_api_server`, `cipher_suites_for_kubelet` and `cipher_suites_for_etcd_server` parameters in the `cluster_config` table to the following:  <small><br><br> TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256 <br>  TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 <br> TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305 <br> TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 <br> TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305 <br> TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 <br> TLS_RSA_WITH_AES_256_GCM_SHA384 <br> TLS_RSA_WITH_AES_128_GCM_SHA256  </small><br><br>Default: `false` |

## registries array (optional)

An array of tables that specifies the MSR instances that are managed by
the current MKE instance.

| Parameter      | REQD | Description                                                                                                                                                         |
|----------------|------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `host_address` | yes  | Sets the address for connecting to the MSR instance tied to the MKE cluster.                                                                                        |
| `service_id`   | yes  | Sets the MSR instance's OpenID Connect Client ID, as registered with the Docker authentication provider.                                                            |
| `ca_bundle`    | no   | Specifies the root CA bundle for the MSR instance if you are using a custom certificate authority (CA). The value is a string with the contents of a `ca.pem` file. |

## audit_log_configuration table (optional)

Configures audit logging options for MKE components.

| Parameter                           | REQD | Description                                                                                                                                                    |
|-------------------------------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `level`                             | no       | Specifies the audit logging level.  <br><br>Valid values: empty (to disable audit logs), `metadata`, `request`.  <br><br>Default: empty                                        |
| `support_dump_include_audit_logs` | no       | Sets support dumps to include audit logs in the logs of the `ucp-controller` container of each manager node.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false` |

## scheduling_configuration table (optional)

Specifies scheduling options and the default orchestrator for new nodes.

{{< callout type="info" >}} If you run a `kubectl`{.interpreted-text
role="command"} command, such as `kubectl describe nodes`{.interpreted-text
role="command"}, to view scheduling rules on Kubernetes nodes, the results that
present do not reflect the MKE admin settings conifguration. MKE uses taints to
control container scheduling on nodes and is thus unrelated to the
`kubectl`{.interpreted-text role="command"} `Unschedulable` boolean flag.
{{< /callout >}}

| Parameter                           | REQD | Description                                                                                                                                                    |
|-------------------------------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `level`                             | no       | Specifies the audit logging level.  <br><br>Valid values: empty (to disable audit logs), `metadata`, `request`.  <br><br>Default: empty                                        |
| `support_dump_include_audit_logs` | no       | Sets support dumps to include audit logs in the logs of the `ucp-controller` container of each manager node.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false` |

## tracking_configuration table (optional)

Specifies the analytics data that MKE collects.

| Parameter            | REQD | Description                                                                                         |
|----------------------|----------|-----------------------------------------------------------------------------------------------------|
| `disable_usageinfo` | no       | Set to disable analytics of usage information.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false`    |
| `disable_tracking`  | no       | Set to disable analytics of API call information.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false` |
| `cluster_label`      | no       | Set a label to be included with analytics.                                                          |
| `ops_care`           | no       | Set to enable OpsCare.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false`                            |

## trust_configuration table (optional)

Specifies whether MSR images require signing.

| Parameter                | REQD | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
|--------------------------|----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `require_content_trust`  | no       | Set to require the signing of images by content trust.  Valid values: `true`, `false`  Default: `false`  You can also set the parameter using the MKE web UI:  <br><br>1. Log in to the MKE web UI as an administrator. <br>2. Click the user name drop-down in the left-side navigation panel. <br>3. Click **Admin Settings > Docker Content Trust** to open the **Content Trust Settings** screen. <br>4. Toggle on the **Run only signed images** slider. |
| `require_signature_from` | no       | A string array that specifies which users or teams must sign images.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `allow_repos`            | no       | A string array that specifies repos that are to bypass content trust check, for example, `["docker.io/mirantis/dtr-rethink" , "docker.io/mirantis/dtr-registry" ....]`.                                                                                                                                                                                                                                                                                                                                                                                               |


## log_configuration table (optional)

{{< callout type="info" >}} The `log_configuration` feature is deprecated.
{{< /callout >}}

Configures the logging options for MKE components.

| Parameter  | REQD | Description                                                                                                                                                                                      |
|------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `protocol` | no       | The protocol to use for remote logging.  <br><br>Valid values: `tcp`, `udp`.  <br><br>Default: `tcp`                                                                                                             |
| `host`     | no       | Specifies a remote syslog server to receive sent MKE controller logs. If omitted, controller logs are sent through the default Docker daemon logging driver from the `ucp-controller` container. |
| `level`    | no       | The logging level for MKE components.  <br><br>Valid values (syslog priority levels): `debug`, `info`, `notice`, `warning`, `err`, `crit`, `alert`, `emerg`.                                             |

## license_configuration table (optional)

Enables automatic renewal of the MKE license.

| Parameter      | REQD | Description                                                                                                                                                                                                   |
|----------------|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `auto_refresh` | no       | Set to enable attempted automatic license renewal when the license nears expiration. If disabled, you must manually upload renewed license after expiration.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `true` |

## custom headers (optional)

Included when you need to set custom API headers. You can repeat this
section multiple times to specify multiple separate headers. If you
include custom headers, you must specify both `name` and `value`.

`[[custom_api_server_headers]]`

| Item    | Description                                                                         |
|---------|-------------------------------------------------------------------------------------|
| `name`  | Set to specify the name of the custom header with `name` =*"X-Custom-Header-Name"*. |
| `value` | Set to specify the value of the custom header with `value` = “Custom Header Value”. |

## user_workload_defaults (optional)

A map describing default values to set on Swarm services at creation
time if those fields are not explicitly set in the service spec.

`[user_workload_defaults]`

`[user_workload_defaults.swarm_defaults]`

| Parameter                                | REQD | Description                                                                                                                                                                                                                                                             |
|------------------------------------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [tasktemplate.restartpolicy.delay]       | no        | Delay between restart attempts. The value is input in the <number><value type> formation. <br><br>Valid value types include: <br><br>* `ns` = nanoseconds<br>* `us` = microseconds<br>* `ms`  = milliseconds<br>* `s` = seconds<br>* `m` = minutes<br>* `h` = hours <br><br>Default:   `value = "5s"` |
| [tasktemplate.restartpolicy.maxattempts] | no        | Maximum number of restarts before giving up. <br><br>Default: `value = "3"`                                                                                                                                                                                             |

## cluster_config table (required) {#cluster-config}

Configures the cluster that the current MKE instance manages.

The `dns`, `dns_opt`, and `dns_search` settings configure the DNS
settings for MKE components. These values, when assigned, override the
settings in a container `/etc/resolv.conf` file.

| Parameter             | REQD | Description                                                               |
|-----------------------|------|---------------------------------------------------------------------------|
| `controller_port`     | yes  | Sets the port that the `ucp-controller` monitors.  <br><br>Default: `443` |
| `kube_apiserver_port` | yes  | Sets the port the Kubernetes API server monitors.                         |
| `kube_protect_kernel_defaults` | no   | Protects kernel parameters from being overridden by kubelet. <br><br>Default:   `false`.  {{< callout type="important" >}} When enabled, kubelet can fail to start if the following kernel parameters are not properly set on the nodes before you install MKE or before adding a new node to an existing cluster:<br><br>``` vm.panic_on_oom=0 vm.overcommit_memory=1 kernel.panic=10 kernel.panic_on_oops=1 kernel.keys.root_maxkeys=1000000 kernel.keys.root_maxbytes=25000000 ``` {{< /callout >}} |
| `kube_api_server_auditing` | no   | Enables auditing to the log file in the `kube-apiserver` container.  {{< callout type="important" >}} Prior to using `kube_api_server_auditing` you must first enable auditing in MKE. Before you enable the `kube_api_server_auditing` option, verify that it does not conflict with MKE options that are already set. {{< /callout >}}  <br>For more information, refer to the official Kubernetes documentation [Troubleshooting Clusters - Audit backends](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/#log-backend).<br><br>Default: `false`. |
| `swarm_port`      | yes | Sets the port that the `ucp-swarm-manager` monitors.  <br><br>Default: `2376`                                                                                   |
| `swarm_strategy` | no  | Sets placement strategy for container scheduling. Be aware that this does not affect swarm-mode services.  <br><br>Valid values: `spread`, `binpack`, `random`. |
| `dns`             | yes | Array of IP addresses that serve as nameservers.                                                                                                        |
| `dns_opt`         | yes | Array of options in use by DNS resolvers.                                                                                                               |
| `dns_search`      | yes | Array of domain names to search whenever a bare unqualified host name is used inside of a container.                                                    |
| `profiling_enabled`   | no        | Determines whether specialized debugging endpoints are enabled for profiling MKE performance.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false`                                                                                                                                                                                                                                                               |
| `authz_cache_timeout` | no        | Sets the timeout in seconds for the RBAC information cache of MKE non-Kubernetes resource listing APIs. Setting changes take immediate effect and do not require a restart of the MKE controller.  <br><br>Default: `0` (cache is not enabled)  <br><br>Once you enable the cache, the result of non-Kubernetes resource listing APIs only reflects the latest RBAC changes for the user when the cached RBAC info times out. |
| `kv_timeout`           | no        | Sets the key-value store timeout setting, in milliseconds.  <br><br>Default: `5000`                                                                                                                                                                                                                                                                                                                                   |
| `kv_snapshot_count`   | REQD | Sets the key-value store snapshot count.  <br><br>Default: `20000`                                                                                                                                                                                                                                                                                                                                                    |
| `external_service_lb` | no        | Specifies an optional external load balancer for default links to services with exposed ports in the MKE web interface.                                                                                                                                                                                                                                                                                       |
| `cni_installer_url`           | no | Specifies the URL of a Kubernetes YAML file to use to install a CNI plugin. Only applicable during initial installation. If left empty, the default CNI plugin is put to use. |
| `metrics_ retention_time`      | no | Sets the metrics retention time.                                                                                                                                              |
| `metrics_scrape_interval`     | no | Sets the interval for how frequently managers gather metrics from nodes in the cluster.                                                                                       |
| `metrics_disk_usage_interval` | no | Sets the interval for the gathering of storage metrics, an operation that can become expensive when large volumes are present.                                                |
| `nvidia_device_plugin`        | no | Enables the `nvidia-gpu-device-plugin`, which is disabled by default.                                                                                                         |
| `rethinkdb_cache_size`             | no  | Sets the size of the cache for MKE RethinkDB servers.  Default: 1GB  Leaving the field empty or specifying `auto` instructs RethinkDB to automatically determine the cache size. |
| `exclude_server_id entity_headers` | no  | Determines whether the `X-Server-Ip` and `X-Server-Name` headers are disabled.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false`                                                 |
| `cloud_provider`                   | no  | Sets the cloud provider for the Kubernetes cluster.                                                                                                                              |
| `pod_cidr`                          | yes | Sets the subnet pool from which the IP for the Pod should be allocated from the CNI IPAM plugin.  <br><br>Default: `192.168.0.0/16`                                                      |
| `ipip_mtu`                          | no  | Sets the IPIP MTU size for the Calico IPIP tunnel interface.                                                                                                                     |
| `azure_ip_count`                        | yes | Sets the IP count for Azure allocator to allocate IPs per Azure virtual machine.                                                                                                                                                                                       |
| `service_cluster_ip_range`              | yes | Sets the subnet pool from which the IP for Services should be allocated.  <br><br>Default: `10.96.0.0/16`                                                                                                                                                                      |
| `nodeport_range`                        | yes | Sets the port range for Kubernetes services within which the type `NodePort` can be exposed.  <br><br>Default: `32768-35535`                                                                                                                                                   |
| `custom_kube_api_server_flags`          | no  | Sets the configuration options for the Kubernetes API server.  Be aware that this parameter function is only for development and testing. Arbitrary Kubernetes configuration parameters are not tested and supported under the MKE Software Support Agreement.         |
| `custom_kube_controller_manager_flags` | no  | Sets the configuration options for the Kubernetes controller manager.  Be aware that this parameter function is only for development and testing. Arbitrary Kubernetes configuration parameters are not tested and supported under the MKE Software Support Agreement. |
| `custom_kubelet_flags`             | no | Sets the configuration options for `kubelet`.  Be aware that this parameter function is only for development and testing. Arbitrary Kubernetes configuration parameters are not tested and supported under the MKE Software Support Agreement.               |
| `custom_kubelet_flags_profiles`   | no | Sets a profile that can be applied to the kubelet agent on any node.                                                                                                                                                                                         |
| `custom_kube_scheduler_flags`      | no | Sets the configuration options for the Kubernetes scheduler.  Be aware that this arameter function is only for development and testing. Arbitrary Kubernetes configuration parameters are not tested and supported under the MKE Software Support Agreement. |
| `local_volume_collection_mapping` | no | Set to store data about collections for volumes in the MKE local KV store instead of on the volume labels. The parameter is used to enforce access control on volumes.                                                                                       |
| `manager_kube_reserved_resources` | no | Reserves resources for MKE and Kubernetes components that are running on manager nodes.                                                                                                                                                                      |
| `worker_kube_reserved_resources` | no  | Reserves resources for MKE and Kubernetes components that are running on worker nodes.                                                                                                                    |
| `kubelet_max_pods`                | yes | Sets the number of Pods that can run on a node.  <br><br>Maximum: `250`<br>Default: `110`                                                                                                                           |
| `kubelet_pods_per_core`           | no  | Sets the maximum number of Pods per core.  `0` indicates that there is no limit on the number of Pods per core. The number cannot exceed the `kubelet_max_pods` setting.  <br><br>Recommended: `10`  <br>Default: `0` |
| `secure_overlay`                  | no  | Enables IPSec network encryption in Kubernetes.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false`                                                                                                         |
| `image_scan_aggregation_enabled` | no  | Enables image scan result aggregation. The feature displays image vulnerabilities in shared resource/containers and shared resources/images pages.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false`      |
| `swarm_polling_disabled` | no | Determines whether resource polling is disabled for both Swarm and Kubernetes resources, which is recommended for production instances.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false` |
| `oidc_client_id`         | no | Sets the OIDC client ID, using the eNZi service ID that is in the ODIC authorization flow.                                                                                                |
| `hide_swarm_ui ` | no | Determines whether the UI is hidden for all Swarm-only object types (has no effect on **Admin Settings**).  <br><br>Valid values: `true`, `false`.<br><br>Default: `false` <br><br>You can also set the parameter using the MKE web UI:<br><br>  1. Log in to the MKE web UI as an administrator. <br>2. In the left-side navigation panel, click the user name drop-down. <br>3. Click **Admin Settings > Tuning** to open the  **Tuning**  screen. <br>4. Toggle on the  **Hide Swarm Navigation**  slider located under the  **Configure MKE UI** heading. |
| `unmanaged_cni`                       | yes | Sets Calico as the CNI provider, managed by MKE. Note that Calico is the default CNI provider.                  |
| `calico_ebpf_enabled`                | yes | Enables Calico eBPF mode.                                                                                       |
| `kube_default_drop_masq_bits`        | yes | Sets the use of Kubernetes default values for iptables drop and masquerade bits.                                |
| `kube_proxy_mode`                    | yes | Sets the operational mode for `kube-proxy`.  <br><br>Valid values: `iptables`, `ipvs`, `disabled`.  <br><br>Default: `iptables` |
| `cipher_suites_for_kube_api_server` | no  | Sets the value for the `kube-apiserver` `--tls-cipher-suites` parameter.                                        |
| `cipher_suites_for_kubelet`      | no | Sets the value for the `kubelet` `--tls-cipher-suites` parameter. |
| `cipher_suites_for_etcd_server` | no | Sets the value for the `etcd` server `--cipher-suites` parameter. |
| `image_prune_schedule` | no | Sets the cron expression used for the scheduling of image pruning. The parameter accepts either full crontab specifications or descriptors, but not both. <br><br> * Full crontab specifications, which include `<seconds> <minutes> <hours> <day of month> <month> <day of week>`. For example,  `"0 0 0 * * *"`.<br> * Descriptors, which are textual in nature, with a preceding @ symbol. For example: `"@midnight"` or `"@every 1h30m"`. <br><br> Refer to the [cron documentation](https://pkg.go.dev/github.com/robfig/cron#hdr-CRON_Expression_Format) for more information. |
| `cpu_usage_banner_threshold` | no | Sets the CPU usage threshold, above which the MKE web UI displays a warning banner.  <br><br>Default: `20`. |
| `cpu_usage_banner_scrape_interval` | no | Sets the MKE CPU usage measurement interval, which enables the function of the `cpu_usage_banner_threshold`  option.<br><br>Default: `"10m"`. |
| `etcd_storage_quota`                         | no | Sets the etcd storage size limit.  Example values: `4GB`, `8GB`.  <br><br>Default value: `2GB`. |
| `nvidia_device_partitioner`                  | no | Enables the NVIDIA device partitioner.  <br><br>Default: `true`.                                |
| `kube_api_server_profiling_enabled`         | no | Enables profiling for the Kubernetes API server.  <br><br>Default: `true`.                      |
| `kube_controller_manager_profiling_enabled` | no | Enables profiling for the Kubernetes controller manager.  <br><br>Default: `true`.              |
| `kube_scheduler_profiling_enabled`          | no | Enables profiling for the Kubernetes scheduler.  <br><br>Default: `true`.                       |
| `kube_scheduler_bind_to_all` | no | Enables kube scheduler to bind to all available network interfaces, rather than just localhost.  <br><br>Default: `false`.                                                                                 |
| `use_flex_volume_driver`     | no | Extends support of FlexVolume drivers, which have been [deprecated since the release of MKE 3.4.13](https://docs.mirantis.com/mke/3.4/release-notes/3-4-13.html#deprecations).  <br><br>Default: `false`. |
| `pubkey_auth_cache_enabled` | no | {{< callout type="warning" >}}   Implement `pubkey_auth_cache_enabled` only in cases in which there are certain performance issues in high-load clusters, and only under the guidance of Mirantis Support personnel. {{< /callout >}}  <br>Enables public key authentication cache.  {{< callout type="info" >}}  `ucp-controller` must be restarted for setting changes to take effect. {{< /callout >}} <br> Default: `false`. |
| `prometheus_memory_limit`                   | no | The maximum amount of memory that can be used by the Prometheus container.  <br><br>Default: `2Gi`.                                                                              |
| `prometheus_memory_request`                 | no | The minimum amount of memory reserved for the Prometheus container.  <br><br>Default: `1Gi`.                                                                                     |
| `shared_sans`                                | no | Subject alternative names for manager nodes.                                                                                                                             |
| `kube_manager_terminated_pod_gc_threshold` | no | Allows users to set the threshold for the terminated Pod garbage collector in Kube Controller Manager according to their cluster-specific requirement.  <br><br>Default: `12500` |
| `kube_api_server_request_timeout`          | no | Timeout for Kube API server requests.  <br><br>Default: `1m`                                                                                                                     |
| `cadvisor_enabled`                                         | no | Enables the `ucp-cadvisor` comoponent, which runs a standalone cadvisor instance on each node to provide additional container level metrics with all expected labels.  <br><br>Default: `false`                                 |
| `calico_controller_probes_tuning`                         | no | Enables the user to specify values for the Calico controller liveness and readiness probes.  <br><br>Default: `false`.                                                                                                          |
| `calico_controller_liveness_probe_failure_threshold`     | no | Sets the Calico controller liveness probe failure threshold.  <br><br>Default: `0`. The default value is not valid and must be changed to a valid value when `calico_controller_probes_tuning` is set to `true`.                |
| `calico_controller_liveness_probe_initial_delay_seconds` | no | Sets the Calico controller liveness probe initial delay period in seconds.  <br><br>Default: `-1`. The default value is not valid and must be changed to a valid value when `calico_controller_probes_tuning` is set to `true`. |
| `calico_controller_liveness_probe_period_seconds`        | no | Sets the Calico controller liveness probe period in seconds.  <br><br>Default: `0`. The default value is not valid and must be changed to a valid value when `calico_controller_probes_tuning` is set to `true`.                |
| `calico_controller_liveness_probe_success_threshold`      | no | Sets the Calico controller liveness probe success threshold.  <br><br>Default: `0`. The default value is not valid and must be changed to a valid value when `calico_controller_probes_tuning` is set to `true`.                 |
| `calico_controller_liveness_probe_timeout_seconds`        | no | Sets the Calico controller liveness probe timeout period in seconds.  <br><br>Default: `0`. The default value is not valid and must be changed to a valid value when `calico_controller_probes_tuning` is set to `true`.         |
| `calico_controller_readiness_probe_failure_threshold`     | no | Sets the Calico controller readiness probe failure threshold.  <br><br>Default: `0`. The default value is not valid and must be changed to a valid value when `calico_controller_probes_tuning` is set to `true`.                |
| `calico_controller_readiness_probe_initial_delay_seconds` | no | Sets the Calico controller readiness probe initial delay period in seconds.  <br><br>Default: `-1`. The default value is not valid and must be changed to a valid value when `calico_controller_probes_tuning` is set to `true`. |
| `calico_controller_readiness_probe_period_seconds`    | no  | Sets the Calico controller readiness probe period in seconds.  <br><br>Default: `0`. The default value is not valid and must be changed to a valid value when `calico_controller_probes_tuning` is set to `true`.         |
| `calico_controller_readiness_probe_success_threshold` | no  | Sets the Calico controller readiness probe success threshold.  <br><br>Default: `0`. The default value is not valid and must be changed to a valid value when `calico_controller_probes_tuning` is set to `true`.         |
| `calico_controller_readiness_probe_timeout_seconds`   | no  | Sets the Calico controller readiness probe timeout period in seconds.  <br><br>Default: `0`. The default value is not valid and must be changed to a valid value when `calico_controller_probes_tuning` is set to `true`. |
| `kube_api_server_audit_log_maxage`                     | no  | Sets the maximum number of days for which to retain old audit log files in Kubernetes API server.  <br><br>Default: `30`.                                                                                                 |
| `kube_api_server_audit_log_maxbackup`                  | no  | Sets the maximum number of audit log files for which to retain in the Kubernetes API server.  <br><br>Default: `10`.                                                                                                      |
| `kube_api_server_audit_log_maxsize`                    | no  | Sets the maximum size the audit log file can attain, in megabytes, before it is rotated in Kubernetes API server.  <br><br>Default: `10`.                                                                                 |
| `KubeAPIServerCustomAuditPolicyYaml`                   | no  | Specifies a Kubernetes audit logging policy. Refer to the [official Kubernetes Auditing documentation](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/) for more information.                                                                        |
| `KubeAPIServerEnableCustomAuditPolicy`                 | no  | Enables the use of a specified custom audit policy yaml file.  <br><br>Default: `false`.                                                                                                                                  |
| `node_exporter_port`                                    | yes | Sets the listening port for Prometheus Node Exporter.  <br><br>Default: `9100`.                                                                                                                                           |

## cluster_config.image_prune_whitelist (optional) {#image-prune-whitelist}

Configures the images that you do not want removed by MKE image pruning.

{{< callout type="info" >}} Where possible, use the image ID to specify the
image rather than the image name.
{{< /callout >}}

| Parameter | REQD | Description                                                                                                                                                                                                                                    |
|-----------|-----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `key`     | yes       | Sets the filter key.  <br><br>Valid values: `dangling`, `label`, `before`, `since`, and `reference`.  For more information, refer to the [official Docker Filtering documentation](https://docs.docker.com/engine/reference/commandline/images/#filtering). |
| `value`   | yes       | Sets the filter value.  For more information, refer to the [official Docker Filtering documentation](https://docs.docker.com/engine/reference/commandline/images/#filtering).                                                                       |

## cluster_config.ingress_controller (optional) {#ingress_controller_config_option}

Set the configuration for the NGINX Ingress Controller to manage traffic
that originates outside of your cluster (ingress traffic).

{{< callout type="info" >}} Prior versions of MKE use Istio Ingress to manage
traffic that originates from outside of the cluster, which employs many of the
same parameters as NGINX Ingress Controller. {{< /callout >}}

| Parameter                     | REQD | Description                                                                                     |
|-------------------------------|-----------|-------------------------------------------------------------------------------------------------|
| `enabled`                     | No        | Disables HTTP ingress for Kubernetes.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false`         |
| `ingress_num_replicas`       | No        | Sets the number of NGINX Ingress Controller deployment replicas.  <br><br>Default: `2`                  |
| `ingress_external_ips`       | No        | Sets the list of external IPs for Ingress service.  <br><br>Default: `[]` (empty)                       |
| `ingress_enable_lb`          | No        | Enables an external load balancer.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false`            |
| `ingress_preserve_client_ip` | No        | Enables preserving inbound traffic source IP.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false` |
| `ingress _exposed_ports` | No | Sets ports to expose.  For each port, provide arrays that contain the following port information (defaults as displayed):  <br><br>*  name = `http2` <br>*  port = `80` <br>*  target_port = `0` <br>*  node_port = `33000`   <br><br>* name = `https` <br>*  port = `443` <br>*  target_port = `0` <br>*  node_port = `33001` <br><br>* name = `tcp` <br>*  port = `31400` <br>*  target_port = `0` <br>*  node_port = `33002` |
| `ingress _node_affinity` | No | Sets node affinity.<br><br>*  key = `com.docker.ucp.manager` <br>*  value = `""` <br>*  target_port = `0` <br>*  node_port = `0`    |
| `ingress _node_toleration` | No | Sets node toleration.<br><br>*  key = `com.docker.ucp.manager` <br>*  value = `""` <br>*  operator = `Exists` <br>*  effect = `NoSchedule`    |
| `config_map` | No | Sets advanced options for the NGINX proxy.  NGINX Ingress Controller uses `ConfigMap` to configure the NGINX proxy. For the complete list of available options, refer to the official NGINX Ingress Controller documentation [ConfigMap: configuration options](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#configuration-options). <br><br> Examples: <br><br> * `map-hash-bucket-size = "128"` <br>* `ssl-protocols = "SSLv2"` |
| `ingress_extra_args.http_port`                | No | Sets the container port for servicing HTTP traffic.  <br><br>Default: `80`                                                                                     |
| `ingress_extra_args.https_port`              | No | Sets the container port for servicing HTTPS traffic.  <br><br>Default: `443`                                                                                   |
| `ingress_extra_args.enable_ssl_passthrough`  | No | Enables SSL passthrough.  <br><br>Default: `false`                                                                                                             |
| `ingress_extra_args.default_ssl_certificate` | No | Sets the Secret that contains an SSL certificate to be used as a default TLS certificate.  <br><br>Valid value: `<namespace>`/`<name>`                         |
| `ingress_extra_args.default_backend_service` | No | Set `--default-backend-service` arg for NGINX Ingress Controller. Enter the value in namespace/service format. Variable substitution is not permitted. |

## cluster_config.metallb_config (optional) {#psp-table}

Enable and disable MetalLB for load balancer services in bare metal
clusters.

| Parameter              | REQD | Description                                                                                                                          |
|------------------------|-----------|--------------------------------------------------------------------------------------------------------------------------------------|
| `enabled`              | No        | Enables MetalLB load balancer for bare metal Kubernetes clusters.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false`. |
| `metallb_ip_addr_pool` | No        | Adds a list of custom address pool resources. At least one entry is required to enable MetalLB. <br><br>Default: [] (empty).         |

## cluster_config.policy_enforcement.gatekeeper (optional) {#gatekeeper-table}

Enable and disable OPA Gatekeeper for policy enforcement.

{{< callout type="info" >}} By design, when the OPA Gatekeeper is disabled
using the configuration file, the Pods are deleted but the policies are not
cleaned up. Thus, when the OPA Gatekeeper is re-enabled, the cluster can
immediately adopt the existing policies.

The retention of the policies poses no risk, as they are just data on
the API server and have no value outside of a OPA Gatekeeper deployment. {{<
/callout >}}

| Parameter             | REQD | Description                                                                                                                                                                                                            |
|-----------------------|------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `enabled`             | No   | Enables the Gatekeeper function.  <br><br>Valid values: `true`, `false`.  <br><br>Default: `false`.                                                                                                                    |
| `excluded_namespaces` | No   | Excludes from the Gatekeeper admission webhook all of the resources that are contained in a list of namespaces. Specify as a comma-separated list. <br><br> Examples: `"kube-system"`, `"gatekeeper-system"` |

## cluster_config.core_dns_lameduck_config (optional) {#lameduck-table}

Enable and disable lameduck in CoreDNS.

| Parameter | REQD | Description                                                                              |
|-----------|-----------|------------------------------------------------------------------------------------------|
| `enabled` | No        | Enables the lameduck health function.  Valid values: `true`, `false`.  Default: `false`. |
| `duration` | No | Length of time during which lameduck will run, expessed with integers and time suffixes, such as `s` for seconds and `m` for minutes.  <br>{{< callout type="info" >}} The configured value for `duration` must be greater than `0s`. Default values are applied for any fields that are left blank.  {{< /callout >}}   <br>Default: `7s`. |

{{< callout type="caution" >}}

Editing the CoreDNS config map outside of MKE to configure the lameduck
function is not supported. Any such attempts will be superseded by the
values that are configured in the MKE configuration file.
{{< /callout >}}

## iSCSI (optional)

Configures iSCSI options for MKE.

| Parameter                 | REQD | Description                                                                                             |
|---------------------------|----------|---------------------------------------------------------------------------------------------------------|
| `--storage-iscsi=true`   | no       | Enables iSCSI-based Persistent Volumes in Kubernetes.  Valid values: `true`, `false`.  <br><br>Default: `false` |
| `--iscsiadm-path=<path>` | no       | Specifies the path of the `iscsiadm` binary on the host.  <br><br>Default: `/usr/sbin/iscsiadm`                 |
| `--iscsidb-path=<path>`  | no       | Specifies the path of the `iscsi` database on the host.  <br><br>Default: `/etc/iscsi`                          |

## pre_logon_message

Configures a pre-logon message.

| Parameter           | REQD |   Description                                                  |
|---------------------|------|----------------------------------------------------------------|
| `pre_logon_message` | no   | Sets a pre-logon message to alert alert users prior to log in. |

## backup_schedule_config (optional) {#backup-schedule-config}

Configures backup scheduling and notifications for MKE.

| Parameter            | REQD | Description                                                                                                                                                                                                                           |
|----------------------|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `notification-delay` | yes       | Sets the number of days that elapse before a user is notified that they have not performed a recent backup. Set to `-1` to disable notifications.  Default: `7`                                                                       |
| `enabled`            | yes       | Enables backup scheduling.  Valid values: `true`, `false`.  Default: `false`                                                                                                                                                          |
| `path`               | yes       | Sets the storage path for scheduled backups. Use `chmod o+w /<path>` to ensure that other users have write privileges.                                                                                                                |
| `no_passphrase`      | yes       | Sets whether a passphrase is necessary to encrypt the TAR file. A value of `true` negates the use of a passphrase. A non-empty value in the `passphrase` parameter requires that `no-passphrase` be set to `false`.  Default: `false` |
| `passphrase`         | yes       | Encrypts the TAR file with a passphrase for all scheduled backups. Must remain empty if `no_passphrase` is set to `true`.  Do not share the configuration file if a passphrase is used, as the passphrase displays in plain text.     |
| `cron_spec` | yes | Sets the cron expression in use for scheduling backups. The parameter accepts either full crontab specifications or descriptors, but not both. <br><br>* Full crontab specifications include `<seconds> <minutes> <hours> <day of month> <month> <day of week>`. For example: `"0 0 0 * * *"` <br><br>* Descriptors, which are textual in nature, have a preceding symbol. For example: `"@midnight"` or `"@every 1h30m"`. For more information, refer to the official [cron documentation](https://pkg.go.dev/github.com/robfig/cron#hdr-CRON_Expression_Format). |
| `include_logs`  | yes | Determines whether a log file is generated in addition to the backup.                                                                |
| `backup_limits` | yes | Sets the number of backups to store. Once this number is reached, older backups are deleted. Set to `-1` to disable backup rotation. |

## etcd_cleanup_schedule_config (optional) {#etcd-cleanup-schedule-config}

Configures scheduling for etcd cleanup for MKE.

| Parameter                  | REQD | Description                                                                        |
|----------------------------|-----------|------------------------------------------------------------------------------------|
| `cleanup_enabled`          | yes       | Enables etcd cleanup scheduling.  Valid values: `true`, `false`.  <br><br>Default: `false` |
| `min_ttl_to_keep_seconds` | no        | Minimum Time To Live (TTL) for retaining certain events in etcd.  <br><br>Default: `0`     |
| `cron_expression` | yes | Sets the cron expression to use for scheduling backups.<br><br> `cron_expression` accepts either full crontab specifications or descriptors. It does not, though, concurrenlty accept both.<br><br> * Full crontab specifications include `<seconds> <minutes> <hours> <day-of-month> <month> <day-of-week>`. For example, `0 0 0 * * MON` <br><br>  * Descriptors, which are textual in nature, have a preceding @ symbol. For example: “@weekly”, “@monthly” or “@every 72h”. <br><br>The etcd cleanup operation starts with the deletion of the events, which is followed by the compacting of the etcd revisions. The cleanup scheduling inerval must be set for a minimum of 72 hours. Refer to the [official cron documentation](https://pkg.go.dev/github.com/robfig/cron#hdr-CRON_Expression_Format) for more information. |
| `defrag_enabled`          | no | Enables defragmentation of the etcd cluster after successful cleanup.  {{< callout type="warning" >}}   The etcd cluster defragmentation process can cause temporary performance degradation. To minimize possible impact, schedule `cron_expression` to occur during off-peak hours or periods of low activity. {{< /callout >}}  <br>Valid values: `true`, `false`.  <br><br>Default: `false` |
| ` defrag_pause_seconds`   | no | Sets the period of time, in seconds, to pause between issuing defrag commands to etcd members.  <br><br>Default: `60`                                                                                                                                                                                                                                                                           |
| `de frag_timeout_seconds` | no | Sets the period of time, in seconds, that each etcd member is allotted to complete defragmentation. If the defragmentation of a member times out before the process is successfully completed, the entire cluster defragmentation is aborted.  <br><br>Default: `300`                                                                                                                           |
## windows_gmsa {#windows-gmsa}

Configures use of Windows GMSA credentia specifications.

| Parameter      | REQD | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
|----------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `windows_gmsa` | no        | Allows creation of GMSA credential specifications for the Kubernetes cluster, as well as automatic population of full credential specifications for any Pod on which the GMSA credential specification is referenced in the security context of that Pod.  The schema for gmsa credential spec MKE uses is publicly documented at https://github.com/kubernetes-sigs/windows-gmsa/blob/master/charts/gmsa/templates/credentialspec.yaml.  For information on how to enable GMSA and how to obtain different components of the GMSA specification for one or more GMSA accounts in your domain, refer to the official Windows documentation. |
