---
title: Install the MKE CLI
weight: 2
---

Before you can proceed with the MKE installation, you must download and install
`mkectl`, the MKE CLI tool, as well as `k0sctl`. You can do this
automatically using an `install.sh` script, or you can do it manually.

## Install automatically with a script

To automatically install the necessary dependencies, you can use an
`install.sh` script, as exemplified in the following procedure:

1. Install the dependencies by downloading and executing the following shell script:

   ```shell
   sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/MirantisContainers/mke-release/refs/heads/main/install.sh)"
   ```

   If you want to override default dependency versions, pass the
   `MKECTL_VERSION` and `K0SCTL_VERSION` as required. For example:

   ```shell
   sudo K0SCTL_VERSION=0.19.4 /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/MirantisContainers/mke-release/refs/heads/main/install.sh)"
   ```

   If you prefer to run the script in the debug mode for more detailed output and logging,
   set `DEBUG=true`:

   ```shell
   sudo DEBUG=true /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/MirantisContainers/mke-release/refs/heads/main/install.sh)"
   ```

2. Confirm the installations:

   {{< tabs items="mkectl,k0sctl" >}}

   {{< tab >}}

   ```shell
   mkectl version
   ```

   Expected output:

   ```shell
   Version: v4.0.0
   ```

   {{< /tab >}}

   {{< tab >}}

   ```shell
   k0sctl version
   ```

   Expected output:

   ```shell
   version: v0.19.4
   commit: b061291
   ```

   If you passed the `K0SCTL_VERSION=0.17.4` as illustrated above,
   the example output would be:

   ```shell
   version: v0.17.4
   commit: 372a589
   ```

   {{< /tab >}}

{{< /tabs >}}

<!-- Remember to update the dependency versions and to keep them in sync with the versions cited in the Install Manually section below. -->

By default, the script installs the following software:

| Tool      | Default version |
| --------- | --------------- |
| `mkectl`  | v4.0.0          |
| `k0sctl`  | 0.19.4          |

The `install.sh` script detects the operating system and the
underlying architecture, based on which it will install the `k0sctl`
and `mkectl` binaries in `/usr/local/bin`. Thus, you must ensure that
`/usr/local/bin` is in your `PATH` environment variable.

You can now proceed with MKE cluster creation.

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

1. Verify the presence of the following tools on your system:

   <!-- Remember to update the dependency versions and to keep them in sync with the versions cited in the Install Automtaically section above. -->

   | Tool    | Version         | Download                                                    |
   | ------- | --------------- | ----------------------------------------------------------- |
   | k0sctl  | 0.19.4 or later | [download](https://github.com/k0sproject/k0sctl/releases)   |

2. Download the `mkectl` binary from the S3 bucket:

   | Distribution | Architecture | Download                                                                                                          |
   | ------------ | ------------ | ----------------------------------------------------------------------------------------------------------------- |
   | Linux        | x86_64       | [download](https://github.com/mirantiscontainers/mke-release/releases/latest/download/mkectl_linux_x86_64.tar.gz) |
   | MacOS        | x86_64       | [download](https://github.com/mirantiscontainers/mke-release/releases/latest/download/mkectl_darwin_arm64.tar.gz) |

3. Ensure that the `mkectl` binary is executable:

   ```
   chmod +x mkectl
   ```

4. Copy the `mkectl` binary to `/usr/local/bin/`:

   ```
   mv mkectl /usr/local/bin/
   ```
