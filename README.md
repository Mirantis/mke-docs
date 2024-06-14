# The Mirantis Kubernetes Engine (MKE) 4 documentation

The Mirantis Kubernetes Engine 4 documentation set is provided to help system
adminstrators and DevOps professionals to deploy MKE 4, covering key
concepts and functionalities.

---

*Note*

Like the system sofware it seeks to represent, the MKE 4 documentation is also
a pre-release product, intended to evolve as MKE 4 evolves. As such,
feedback on the comprehensiveness and quality of the content herein is both
welcome and essential.

---

### Concepts and Architecture

- [Architecture](content/docs/concepts/architecture/architecture.md)
- [Configuration](content/docs/concepts/architecture/configuration.md)
- [Migrate configuration](content/docs/concepts/architecture/migrate-configuration.md)

### Setup

- Get Started with MKE 4
  - [Prerequisites](content/docs/setup/getting-started/prerequisites.md)
  - [Create a cluster](content/docs/setup/getting-started/create-a-cluster.md)
  - [Using the cluster](content/docs/setup/getting-started/Using-the-cluster.md)
  - [Install MKE 4 CLI](content/docs/setup/getting-started/install-mke4-cli.md)
  - [k0s in AWS](content/docs/setup/getting-started/k0s-in-aws/terraform-scenario.md)
  - [Uninstallation](content/docs/setup/getting-started/uninstallation.md)
- [Upgrade from MKE 3](content/docs/setup/upgrade-from-mke-3/perform-upgrade.md)

### Reference

- [Authentication](content/docs/reference/authentication/authentication.md)
- [Backup and restore](content/docs/reference/backuprestore/backup-restore.md)
- [Ingress controller](content/docs/reference/ingress/ingress-controller.md)
- [Monitoring](content/docs/reference/monitoring/monitoring.md)
- [Support bundle](content/docs/reference/supportbundle/support-bundle.md)

### Known issues

- [Known issues](content/docs/known-issues.md)

### Features

The table that follows details MKE 4 features and their current status. In
addition, where applicable, the table offers links to associated documentation.

| Feature                                                          | Pre-Release | Status   | 
|------------------------------------------------------------------|-------|----------|
| Authentication                                                   | alpha.1| MVP      |  
| Authorization                                                    | alpha.1 | MVP      |   
| [Backup and restore](content/docs/reference/backuprestore/backup-restore.md)    | alpha.1 | MVP      |
| CIS Benchmark                                                    |   |          |
| CLI                                                              |   |          |
| Cloud Providers                                                  |   |          |
| CoreDNS                                                          |   |          |
| cAdvisor                                                         |   |          |
| gMSA                                                             |   |          |
| GPU Feature Discovery                                            |   |          |
| [Ingress](content/docs/reference/ingress/ingress-controller.md)                   | alpha.1| MVP      |   |
| [Kubernetes](content/docs/concepts/architecture/architecture.md#components) | alpha.1 | MVP 1.29 |  |
| Life Cycle Management                                            |   |          |
| Licensing                                                        |   |          |
| Load Balancing                                                   |   |          |
| Logging, Monitoring and Alerting                                 | alpha.1 | MVP      |  
| [Networking (CNI)](content/docs/concepts/architecture/architecture.md#container-network-interface)  |  alpha.1 | MVP      |  
| Node Feature Discovery                                           |   |          |
| Offline Bundle                                                   |   |          |
| OpsCare                                                          |   |          |
| Policy Controller                                                |   |          |
| Storage (CSI)                                                    |   |          |
| Support Dump                                                     |   |          |
| Telemetry                                                        |   |          |
| TLS                                                              |   |          |
| 2FA                                                              |   |          |
| Web UI                                                           | alpha 2  |          |
| Windows                                                          |   |          |
