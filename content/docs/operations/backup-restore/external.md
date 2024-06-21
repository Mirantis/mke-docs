---
title: Use an external storage provider
weight: 2
---

You can configure MKE 4 to store backups and restores externally, for example
in object storage provided by a public cloud provider.

{{< callout type="info" >}}
  AWS S3 is currently the only supported external backup store
  that MKE 4 supports.
{{< /callout >}}

## Configuration

1. Copy the credentials information from the AWS console to create an IAM
credentials file.

   ![img.png](img.png)

2. Edit the `storage_provider` section of the MKE configuration file to point
to the file, including the profile name.

3. Create an S3 bucket and point the configuration to the bucket and region.

Example configuration:

```yaml
  storage_provider:
    type: External
    external_options:
      provider: aws
      bucket: bucket_name
      region: us-west-2
      credentials_file_path: "/path/to/iamcredentials"
      credentials_file_profile: "386383511305_docker-testing"
```

Once you have configured the AWS backup storage and the MKE configuration file
has been applied, verify the existence of the `BackupStorageLocation` custom resource.

```shell
kubectl get backupstoragelocation -n mke
```

After you run `mkectl apply` the output may require a few minutes to display.

Example output:

```shell
NAME      PHASE       LAST VALIDATED   AGE   DEFAULT
default   Available   20s              32s   true
```

## Create backups and perform restores

With configuration complete, you can now create backups and perform restores
from those backups. After you have run a restore operation from a backup, the
Kubernetes cluster state should resemble what it was at the time you created
that backup.

```shell
mkectl backup create --name aws-backup
```

Example output:

```shell
INFO[0000] Creating backup aws-backup...
Backup request "aws-backup" submitted successfully.
Run `velero backup describe aws-backup` or `velero backup logs aws-backup` for more details.
INFO[0000] Waiting for backup aws-backup to complete...
INFO[0003] Waiting for backup to complete. Current phase: InProgress
INFO[0006] Waiting for backup to complete. Current phase: InProgress
INFO[0009] Waiting for backup to complete. Current phase: InProgress
INFO[0012] Waiting for backup to complete. Current phase: InProgress
INFO[0015] Waiting for backup to complete. Current phase: Completed
INFO[0015] Backup aws-backup completed successfully
```

To list the backups, run the `mkectl backup list` command:

```shell
mkectl backup list
```

Example output:

```shell
NAME         STATUS      ERRORS   WARNINGS   CREATED                         EXPIRES   STORAGE LOCATION   SELECTOR
aws-backup   Completed   0        0          2024-05-08 16:17:18 -0400 EDT   29d       default            <none>
```

To perform a restore using an external backup, run:

```shell
mkectl restore create --name aws-backup
```

Example output:

```shell
INFO[0000] Waiting for restore aws-backup-20240508161811 to complete...
INFO[0000] Waiting for restore to complete. Current phase: InProgress
INFO[0003] Waiting for restore to complete. Current phase: InProgress
INFO[0006] Waiting for restore to complete. Current phase: InProgress
INFO[0009] Waiting for restore to complete. Current phase: InProgress
INFO[0012] Waiting for restore to complete. Current phase: InProgress
INFO[0015] Waiting for restore to complete. Current phase: InProgress
INFO[0018] Waiting for restore to complete. Current phase: InProgress
INFO[0021] Waiting for restore to complete. Current phase: InProgress
INFO[0024] Waiting for restore to complete. Current phase: Completed
INFO[0024] Restore aws-backup-20240508161811 completed successfully
```

To list the restores, run:

```shell
mkectl restore list
```

Example output:

```shell
NAME                        BACKUP       STATUS      STARTED                         COMPLETED                       ERRORS   WARNINGS   CREATED                         SELECTOR
aws-backup-20240508161811   aws-backup   Completed   2024-05-08 16:18:11 -0400 EDT   2024-05-08 16:18:34 -0400 EDT   0        108        2024-05-08 16:18:11 -0400 EDT   <none>
```

From your AWS console, you can see that both the backup and restore are created
in the S3 bucket:

![img_1.png](img_1.png)
