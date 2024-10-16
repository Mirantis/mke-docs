---
title: Install virtctl CLI
weight: 3
---

Although it is not required to run KubeVirt, the `virtctl` CLI provides an
interface that can significantly enhance the convenience of your virtual
machine interactions.

1. Obtain the virtctl version for your particular architecture from
   https://binary.mirantis.com/?prefix=kubevirt/bin/artifacts.

2. Run the following command, inserting the correct values for your
   architecture and platform. For `ARCH` the valid values are
   `linux` or `darwin`, and for `PLATFORM` the
   valid values are `amd64` or `arm64`.

   ```bash
   wget https://binary-mirantis-com.s3.amazonaws.com/kubevirt/bin/artifacts/virtctl-1.3.1-20240911005512-<ARCH>-<PLATFORM>  -O virtctl
   ```

   Example command for Linux with amd64 architecture:

   ```bash
   wget https://binary-mirantis-com.s3.amazonaws.com/kubevirt/bin/artifacts/virtctl-1.3.1-20240911005512-linux-amd64 -O virtctl
   ```

   Example command for MacOS with arm64 architecture:

   ```bash
   wget https://binary-mirantis-com.s3.amazonaws.com/kubevirt/bin/artifacts/virtctl-1.3.1-20240911005512-darwin-arm64  -O virtctl
   ```

3. Move virtctl to one of the `PATH` directories.

   {{< callout type="info" >}}
     `PATH` is a system environment variable that contains a list of
     directories, within each of which the system is able to search for a
     binary. To reveal the list, issue the following command:

     ```bash
     echo $PATH
     ```

     Example output:

     ```bash
     /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
     ```

     The PATH directories are each separated by a `:`.
   {{< /callout >}}