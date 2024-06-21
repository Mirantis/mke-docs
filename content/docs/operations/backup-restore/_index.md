---
title: Backup and restore
weight: 2
---

MKE 4 supports backup and restore of cluster data through the use of the
[Velero](https://velero.io/) addon. Backup is enabled by default.

## Configuration

The `backup` section of the MKE4 configuration file renders as follows:

```yaml
backup:
  enabled: true
  storage_provider:
    type: InCluster
    in_cluster_options:
      exposed: true
      distributed: false
```

By default, MKE 4 supports backups that use the in-cluster storage
provider, as indicated in the `type` option setting of `InCluster`. MKE 4
in-cluster backups are implemented using the [MinIO
addon](https://microk8s.io/docs/addon-minio).

The `exposed` option setting of `true` indicates that the MinIO service is
exposed through `NodePort`, which Velero requires to function correctly. Core
backup functionality should work, however, even if
the service is not exposed.

The `distributed` option configures MinIO storage to run in distributed mode.

Refer to the following table for detail on all of the conifguration file
`backup` fields:

| Field                                                      | Description                                                                        | Valid values        |  Default  |
|------------------------------------------------------------|------------------------------------------------------------------------------------|---------------------|:---------:|
| enabled                                                    | Indicates whether backup/restore functionality is enabled.                         | true, false         |    true   |
| storage_provider.type                                      | Indicates whether the storage type in use is in-cluster or external.               | InCluster, External | InCluster |
| storage_provider.in_cluster_options.exposed                | Indicates whether to expose InCluster (MinIO) storage through NodePort.            | true, false         |    true   |
| storage_provider.in_cluster_options.distributed            | Indicates whether to run MinIO in distributed mode.                                | true, false         |   false   |
| storage_provider.external_options.provider                 | Name of the external storage provider. AWS is currently the only available option. | aws                 |    aws    |
| storage_provider.external_options.bucket                   | Name of the pre-created bucket to use for backup storage.                          | ""                  |     ""    |
| storage_provider.external_options.region                   | Region in which the bucket exists.                                                 | ""                  |     ""    |
| storage_provider.external_options.credentials_file_path    | Path to the credentials file.                                                      | ""                  |     ""    |
| storage_provider.external_options.credentials_file_profile | Profile in the Credentials file to use.                                            | ""                  |     ""    |

## Create backups and perform restores

For information on how to create backups and perform restores for both storage
provider types, refer to:

- In-cluster storage provider: [in_cluster.md](in-cluster)
- External storage provider: [external.md](external)

## Existing limitations

- Scheduled backups, an MKE 3 feature that is planned for integration to MKE 4,
  have not yet been implemented.

- Backups must currently be restored in the same cluster in which the backup
  was taken, and thus restoring a backup to a new set of nodes is not yet
  supported for the in-cluster storage provider.