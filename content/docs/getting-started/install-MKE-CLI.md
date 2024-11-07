---
title: Install the MKE CLI
weight: 2
---

Before you can proceed with the MKE installation, you must download and install
`mkectl`, the MKE CLI tool, as well as `kubectl` and `k0sctl`. You can do this
automatically using an `install.sh` script, or you can do it manually.

## Install automatically with a script

To automatically install the necessary dependencies, you can use an
`install.sh` script, as exemplified in the following procedure:

1. Install the dependencies by downloading and executing the following shell script:

   ```shell
   sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Mirantis/mke-docs/main/content/docs/getting-started/install.sh)"
    ```

   If you want to override default dependency versions, pass the `MKECTL_VERSION`, `KUBECTL_VERSION`
   and `K0SCTL_VERSION` as required. For example:

   ```shell
   sudo K0SCTL_VERSION=0.19.0 /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Mirantis/mke-docs/main/content/docs/getting-started/install.sh)"
   ```

   If you prefer to run the script in the debug mode for more detailed output and logging,
   set `DEBUG=true`:

   ```shell
   sudo DEBUG=true /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Mirantis/mke-docs/main/content/docs/getting-started/install.sh)"
   ```

2. Confirm the installations:

   {{< tabs items="mkectl,k0sctl,kubectl" >}}

    {{< tab >}}
      ```shell
       mkectl version
       ```

       Expected output:

       ```shell
       Version: v4.0.0-rc.5
       ```
     {{< /tab >}}

     {{< tab >}}
       ```shell
       k0sctl version
       ```

       Expected output:

       ```shell
       version: v0.19.0
       commit: b061291
       ```

       If you passed the `K0SCTL_VERSION=0.17.4` as illustrated above,
       the example output would be:

       ```shell
       version: v0.17.4
       commit: 372a589
       ```
    {{< /tab >}}

    {{< tab >}}
      ```shell
      kubectl version
      ```

      Expected output:

      ```shell
      Client Version: v1.30.0
      Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
      Server Version: v1.30.3+k0s
      ```
   {{< /tab >}}

{{< /tabs >}}

By default, the script installs the following software:

| Tool     | Default version   |
|----------|-------------------|
| `mkectl` | v4.0.0-rc.5       |
| `k0sctl` | 0.19.0            |
| `kubectl`| v1.30.0           |

The `install.sh` script detects whether `kubectl` is already installed on your
system and will not overwrite it. It also detects the operating system and the
underlying architecture, based on which it will install the `k0sctl`, `kubectl`
and `mkectl` binaries in `/usr/local/bin`. Thus, you must ensure that
` /usr/local/bin` is in your `PATH` environment variable.

You can now proceed with MKE cluster creation.

## Install manually

Download `mkectl` from the S3 bucket:

| Distribution | Architecture | Download |
|--------------|--------------|----------|
| Linux        | arm64        | [download](https://s3.us-east-2.amazonaws.com/packages-stage-mirantis.com/v4.0.0-rc.5/mkectl_linux_arm64.tar.gz) |
| Linux        | x86_64       | [download](https://s3.us-east-2.amazonaws.com/packages-stage-mirantis.com/v4.0.0-rc.5/mkectl_linux_x86_64.tar.gz) |
| MacOS        | arm64        | [download](https://s3.us-east-2.amazonaws.com/packages-stage-mirantis.com/v4.0.0-rc.5/mkectl_darwin_arm64.tar.gz) |
| MacOS        | x86_64       | [download](https://s3.us-east-2.amazonaws.com/packages-stage-mirantis.com/v4.0.0-rc.5/mkectl_darwin_x86_64.tar.gz) |
| Windows      | arm64        | [download](https://s3.us-east-2.amazonaws.com/packages-stage-mirantis.com/v4.0.0-rc.5/mkectl_windows_arm64.zip) |
| Windows      | x86_64       | [download](https://s3.us-east-2.amazonaws.com/packages-stage-mirantis.com/v4.0.0-rc.5/mkectl_windows_x86_64.zip) |

The MKE CLI is a single binary that is capable of managing MKE clusters without
any additional dependencies. Its use, though, requires that you have the
following tools on your system:

| Tool     | Version          | Download |
|----------|------------------|----------|
| kubectl  | 1.30.0 or later  | [download](https://kubernetes.io/docs/tasks/tools/#kubectl) |
| k0sctl   | 0.19.0 or later  | [download](https://github.com/k0sproject/k0sctl/releases) |

