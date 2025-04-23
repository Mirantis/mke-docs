---
title: Offline installation
weight: 3
---

The installation and upgrade procedures for MKE 4k reflect those of the online
scenario. While the online installation, though, typically uses
`registry.mirantis.com` as the primary OCI registry as the repository for MKE
 4k materials, with the offline scenario you instead specify a private
registry from which to pull the MKE 4k artifacts, images, and charts.

{{< callout type="info" >}}

You can download the MKE 4 artifacts from the releases page.

{{< /callout >}}

## Dependencies ##

- skopeo 1.6.1 or later
- An OCI-based private registry that is accessible from all cluster nodes.
- All MKE 4 artifacts and images must be publicly accessible, with no required authentication.
- The registry must use HTTPS, and the TLS certificates of the registry server
must be signed by a publicly trusted Certificate Authority.
- The registry must support multi-level nesting, for image names

## Preparation ##

1. Download the offline bundle from the releases page:

   ```bash
   wget https://packages.mirantis.com/caas/mke_bundle_v4.1.0.tar.gz -O mke_bundle_v4.1.0.tar.gz
   ```

2. Transfer the bundle file to a machine that can access your private registry.

3. On the machine with registry access, set the environment variables:

   ```bash
   export REGISTRY_ADDRESS="<registry_address>"  # Registry hostname and optionally port, e.g. "private-registry.example.com:8080". Must NOT end with a slash '/'
   export REGISTRY_PROJECT_PATH="<registry-path>"  # Path to the registry project that will store all MKE 4 artifacts. Must NOT end with a slash '/'. E.g. "mke". Registry address and path should make the full registry path. With the examples above, the full path will be REGISTRY_ADDRESS + "/" + REGISTRY_PROJECT_PATH == "private-registry.example.com:8080/mke"
   export REGISTRY_USERNAME="<username>"  # Username of the account allowed to push
   export REGISTRY_PASSWORD="<password>"  # Password for the same account
   export BUNDLE_NAME="mke_bundle_v4.1.0-rc.1.tar.gz"  # The name of previously downloaded bundle file. The file must be located in the same directory where you run the preparation steps
   ```

4. Upload the MKE 4k images and helm charts to your private registry:

   ```
   # Login to the registry
   skopeo login "$REGISTRY_ADDRESS" -u "$REGISTRY_USERNAME" -p "$REGISTRY_PASSWORD"

   # Extract the bundle
   tar -xzf "$BUNDLE_NAME" -C ./

   # Iterate over bundle artifacts and upload each one using skopeo
   for archive in $(find ./bundle -print | grep ".tar"); do
     # Form the image name from the archive name
     img=$(basename "$archive" | sed 's~\.tar~~' | tr '&' '/' | tr '@' ':');

     echo "Uploading $img";
     # Copy artifact from local oci archive to the registry
     skopeo copy -q --retry-times 3 --multi-arch all "oci-archive:$archive" "docker://$REGISTRY_ADDRESS/$REGISTRY_PROJECT_PATH/$img";
   done;
   ```

## New Installation ##

1. Refer to the [Create a Cluster](../create-cluster/#initialize-deployment) procedure for detail on
how to create a `mke4.yaml` configuration file.

2. Add the following additional settings to the `mke4.yaml` configuration file:

   | Setting                            | Description                                                                                                                                                                                                                                                                                                                                                                                                                                   |
   |------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
   | `.spec.registries.imageRegistry.URL` | Sets your registry address with a project path that contains your MKE 4 images. For example, `private-registry.example.com:8080/mke`. <br><br>The setting must not end with a slash `/`.<br><br>The port is optional.                                                                                                                                                                                                                                                                   |
   | `.spec.registries.chartRegistry.URL` | Sets your registry address with a project path that contains your MKE 4 helm charts in OCI format. For example, `oci://private-registry.example.com:8080/mke`.<br><br>The setting must always start with  `oci://`, and it must not end with a slash `/` .<br><br>If you uploaded the bundle as previously described, the registry address and path will be the same for chart and image registry, with the only difference being the   `oci://` prefix in the chart registry URL. |
   | `.spec.airgap.enabled = true`        | Indicates that your environment is airgapped. With this setting in place, run proceed with the installation normally by running                                                                                                                                                                                                                                                                                                                         |


3. Run the `mkectl apply` command.

## Upgrade ##

To perform an offline upgrade from MKE 3 to MKE 4k, you adhere to the
procedure as described in [Migrate from MKE 3.x](../../migrate-from-mke-3),
adding the following flags to the `mkectl upgrade` command:

* `--image-registry=<registry_full_path>`
* `--chart-registry=oci://<registry_full_path>`
* `--mke3-airgapped=true`

{{< callout type="info" >}}

For detail on the `mkectl upgrade` command flags, refer to the mke4.yml
configuation file settings descriptions offered above for new installations.

{{< /callout >}}

## MKE 4 versus MKE 3 ##

MKE 3 requires the use of the `docker load` command to load offline bundles
directly into Docker on every cluster node. While this approach does not
require you to have a private registry, it also means that the cluster cannot
repull the image should any of the loaded images go missing. As such, MKE 3
users must disable Kubernetes garbage collection, which can sometimes prune
images of optional components that are not always enabled. This is not an issue
with MKE 4, as images are pulled from a private registry that the customer
provides, and thus there is no need to disable Kubernetes garbage collection.
That said, though, users must ensure that the registry is available at all
times and that it is accessible from every cluster node.