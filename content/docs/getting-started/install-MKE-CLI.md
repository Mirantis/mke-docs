---
title: Install the MKE CLI
weight: 2
---

Before you can proceed with the MKE installation, you need to download and install
`mkectl`, the MKE CLI tool, along with the `kubectl` and `k0sctl` tools, either manually
or using the script provided below.

## Install manually

You can download `mkectl` from the S3 bucket:

| Distribution | Architecture | Download |
|--------------|--------------|----------|
| Linux        | arm64        | [download](https://s3.us-east-2.amazonaws.com/packages-stage-mirantis.com/v4.0.0-alpha1.0/mkectl_linux_arm64.tar.gz) |
| Linux        | x86_64       | [download](https://s3.us-east-2.amazonaws.com/packages-stage-mirantis.com/v4.0.0-alpha1.0/mkectl_linux_x86_64.tar.gz) |
| MacOS        | arm64        | [download](https://s3.us-east-2.amazonaws.com/packages-stage-mirantis.com/v4.0.0-alpha1.0/mkectl_darwin_arm64.tar.gz) |
| MacOS        | x86_64       | [download](https://s3.us-east-2.amazonaws.com/packages-stage-mirantis.com/v4.0.0-alpha1.0/mkectl_darwin_x86_64.tar.gz) |
| Windows      | arm64        | [download](https://s3.us-east-2.amazonaws.com/packages-stage-mirantis.com/v4.0.0-alpha1.0/mkectl_windows_arm64.zip) |
| Windows      | x86_64       | [download](https://s3.us-east-2.amazonaws.com/packages-stage-mirantis.com/v4.0.0-alpha1.0/mkectl_windows_x86_64.zip) |

Envisioned as a single binary, capable of managing MKE clusters without any
additional dependencies, the MKE CLI requires that you have the following
tools installed on your system as well:

| Tool     | Version          | Download |
|----------|------------------|----------|
| kubectl  | 1.29.0 or later  | [download](https://kubernetes.io/docs/tasks/tools/#kubectl) |
| k0sctl   | 0.17.0 or later  | [download](https://github.com/k0sproject/k0sctl/releases) |


## Install using script

To install the required dependencies automatically, use the `install.sh` script:

{{< details title="install.sh" closed="true" >}}

```bash
#!/bin/sh
set -e

PATH=$PATH:/usr/local/bin

if [ -n "${DEBUG}" ]; then
  set -x
fi

detect_uname() {
  os="$(uname)"
  case "$os" in
    Linux) echo "linux" ;;
    Darwin) echo "darwin" ;;
    *) echo "Unsupported operating system: $os" 1>&2; return 1 ;;
  esac
  unset os
}

detect_arch() {
  arch="$(uname -m)"
  case "$arch" in
    amd64|x86_64) echo "x64" ;;
    arm64|aarch64) echo "arm64" ;;
    armv7l|armv8l|arm) echo "arm" ;;
    *) echo "Unsupported processor architecture: $arch" 1>&2; return 1 ;;
  esac
  unset arch
}

# download_k0sctl_url() fetches the k0sctl download url.
download_k0sctl_url() {
  echo "https://github.com/k0sproject/k0sctl/releases/download/v$K0SCTL_VERSION/k0sctl-$uname-$arch"
}

# download_kubectl_url() fetches the kubectl download url.
download_kubectl_url() {
  if [ "$arch" = "x64" ];
  then
    arch=amd64
  fi
  echo "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${uname}/${arch}/kubectl"
}

install_kubectl() {
  if [ -z "${KUBECTL_VERSION}" ]; then
    echo "Using default kubectl version v1.30.0"
    KUBECTL_VERSION=v1.30.0
  fi
  kubectlDownloadUrl="$(download_kubectl_url)"
  echo "Downloading kubectl from URL: $kubectlDownloadUrl"
  curl -sSLf "$kubectlDownloadUrl" >$installPath/$kubectlBinary
  sudo chmod 755 "$installPath/$kubectlBinary"
  echo "kubectl is now executable in $installPath"
}

# download_mkectl downloads the mkectl binary.
download_mkectl() {
  if [ "$arch" = "x64" ] || [ "$arch" = "amd64" ];
  then
    arch=x86_64
  fi
  curl --silent -L -s https://s3.us-east-2.amazonaws.com/packages-stage-mirantis.com/${MKECTL_VERSION}/mkectl_${uname}_${arch}.tar.gz | tar -xvzf - -C $installPath
  echo "mkectl is now executable in $installPath"
}

main() {

  uname="$(detect_uname)"
  arch="$(detect_arch)"

  printf "\n\n"

  echo "Step 1/3 : Install k0sctl"
  echo "#########################"

  if [ -z "${K0SCTL_VERSION}" ]; then
    echo "Using default k0sctl version 0.17.8"
    K0SCTL_VERSION=0.17.8
  fi

  k0sctlBinary=k0sctl
  installPath=/usr/local/bin
  k0sctlDownloadUrl="$(download_k0sctl_url)"


  echo "Downloading k0sctl from URL: $k0sctlDownloadUrl"
  curl -sSLf "$k0sctlDownloadUrl" >"$installPath/$k0sctlBinary"

  sudo chmod 755 "$installPath/$k0sctlBinary"
  echo "k0sctl is now executable in $installPath"

  printf "\n\n"
  echo "Step 2/3 : Install kubectl"
  echo "#########################"

  kubectlBinary=kubectl

  if [ -x "$(command -v "$kubectlBinary")" ]; then
    VERSION="$($kubectlBinary version | grep Client | cut -d: -f2)"
    echo "$kubectlBinary version $VERSION already exists."
  else
    install_kubectl
  fi

  printf "\n\n"
  echo "Step 3/3 : Install mkectl"
  echo "#########################"

  if [ -z "${MKECTL_VERSION}" ]; then
    echo "Using default mkectl version v4.0.0-alpha1.0"
    MKECTL_VERSION=v4.0.0-alpha1.0
  fi
  printf "\n"


  echo "Downloading mkectl"
  download_mkectl

}

main "$@"
```

{{< /details >}}

By default, the script installs the following software:

| Tool     | Default version   |
|----------|-------------------|
| `mkectl` | v4.0.0-alpha.0.3  |
| `k0sctl` | 0.17.8            |
| `kubectl`| v1.30.0           |

The `install.sh` script detects whether `kubectl` is already installed on your
system and will not overwrite it. It also detects the operating system and the
underlying architecture, based on which it will install the `k0sctl`, `kubectl`
and `mkectl` binaries in `/usr/local/bin`. Thus, you must ensure that
` /usr/local/bin` is in your `PATH` environment variable.

**Procedure:**

1. Install the dependencies by downloading and executing the following shell script:

   ```shell
   sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Mirantis/mke-docs/main/content/getting-started/install.sh)"
    ```

   If you want to override default dependency versions, pass the `MKECTL_VERSION`, `KUBECTL_VERSION`
   and `K0SCTL_VERSION` as required. For example:

   ```shell
   sudo K0SCTL_VERSION=0.17.4 /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Mirantis/mke-docs/main/content/getting-started/install.sh)"
   ```

   If you prefer to run the script in the debug mode for more detailed output and logging,
   set `DEBUG=true`:

   ```shell
   sudo DEBUG=true /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Mirantis/mke-docs/main/content/getting-started/install.sh)"
   ```

2. Confirm the installations:

   {{< tabs items="mkectl,k0sctl,kubectl" >}}

    {{< tab >}}
      ```shell
       mkectl version
       ```

       Expected output:

       ```shell
       Version: v4.0.0-alpha.0.3
       ```
     {{< /tab >}}

     {{< tab >}}
       ```shell
       k0sctl version
       ```

       Expected output:

       ```shell
       version: v0.17.8
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
      Server Version: v1.29.3+k0s
      ```
   {{< /tab >}}

{{< /tabs >}}

Now, you can proceed with the MKE cluster creation.
