---
title: Install the MKE 4k CLI
weight: 2
---

Before you can proceed with the MKE 4k installation, you must download and
install `mkectl`. You can do this automatically using an `install.sh` script,
or you can do it manually.

## Install automatically with a script

1. Install `mkectl` by downloading and executing the following shell script:

   ```shell
   sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/MirantisContainers/mke-release/refs/heads/main/install.sh)"
   ```

   If you want to override default dependency versions, pass the
   `MKECTL_VERSION` as required. For example:

   ```shell
   sudo MKECTL_VERSION=4.1.0 /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/MirantisContainers/mke-release/refs/heads/main/install.sh)"
   ```

   If you prefer to run the script in the debug mode for more detailed output and logging,
   set `DEBUG=true`:

   ```shell
   sudo DEBUG=true /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/MirantisContainers/mke-release/refs/heads/main/install.sh)"
   ```

2. Confirm the installation:

   ```shell
   mkectl version
   ```

   Expected output:

   ```shell
   Version: v4.1.0
   ```

   <!-- Remember to update the dependency version and to keep them in sync with the version cited in the Install Manually section below. -->

   {{< callout type="info" >}}

   By default, the script installs mkectl v4.1.0.

   {{< /callout >}}

The `install.sh` script detects the operating system and the
underlying architecture, based on which it will install the `mkectl` binary in `/usr/local/bin`. Thus, you must ensure that
`/usr/local/bin` is in your `PATH` environment variable.

You can now proceed with MKE 4k cluster creation.

## Install using Homebrew

1. Add the `mirantis` repository to your local taps:

   ```shell
   brew tap mirantis/tap
   ```

   {{< callout type="info" >}}

   If the `mirantis` tap is already present and you want to update it, run:

   ```shell
   brew update
   ```

   {{< /callout >}}

2. Install `mkectl`:

   - To install the latest `mkectl` version:

     ```shell
     brew install mkectl
     ```

   - To install a specific `mkectl` version:

     ```shell
     brew install mkectl@<version-number>
     ```

## Install manually

1. Download the `mkectl` binary from the S3 bucket:

   | Distribution | Architecture | Download                                                                                                          |
   | ------------ | ------------ | ----------------------------------------------------------------------------------------------------------------- |
   | Linux        | x86_64       | [download](https://github.com/mirantiscontainers/mke-release/releases/latest/download/mkectl_linux_x86_64.tar.gz) |
   | MacOS        | x86_64       | [download](https://github.com/mirantiscontainers/mke-release/releases/latest/download/mkectl_darwin_arm64.tar.gz) |

2. Ensure that the `mkectl` binary is executable:

   ```
   chmod +x mkectl
   ```

3. Copy the `mkectl` binary to `/usr/local/bin/`:

   ```
   mv mkectl /usr/local/bin/
   ```
