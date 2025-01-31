---
title: Upgrade from prior MKE 4 install
weight: 2
---

Instruction on how to upgrade your MKE 4 installation to the latest version is
provided herein.

## Prerequisites

1. [Make a backup of the existing cluster](../../configuration/backup-restore#create-a-backup-and-perform-a-restore).

2. [Download the latest mkectl binary](../../getting-started/install-mke-cli).

   ```
   % mkectl version
   Version: v4.0.1-beta.1
   ```

3. Run the `upgrade` command:

   ```
   % mkectl upgrade --config-out <path-to-desired-file-location>
   ```

{{< callout type="info" >}} Unlike migrations from MKE 3, none of the upgrade
parameters are supported for minor/patch upgrades. {{< /callout >}}

The MKE components upgrade to the versions defined at https://github.com/MirantisContainers/mke-release/blob/main/release-matrix/release-matrix.json