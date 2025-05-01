---
title: Support bundle
weight: 4
---

To generate support bundles directly from the command line, you must have the
kubectl extension support bundle plugin installed.

## Install the support bundle plugin

You can install the support bundle plugin using Krew plugin manager, or you can
obtain the support bundle plugin from the release archives and install it manually.

{{< tabs items="Krew installation,Manual installation" >}}

    {{< tab >}}
    1. Optional. Install the Krew plugin manager if is not yet installed on your
       system. For detailed instruction, refer to the official Krew documentaiton
       [Installing](https://krew.sigs.k8s.io/docs/user-guide/setup/install/).
    
    2. Install the support bundle plugin:
        
       ```commandline
       kubectl krew install support-bundle


    3. Append the ``$HOME/.krew/bin`` directory to your ``$PATH`` environment variable:

       ```commandline
       export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
       ```

    4. Verify the support bundle plugin installation:

       1. Restart your shell.

       2. Run the ``kubectl krew`` command.
    
    {{< /tab >}}
    
    {{< tab >}}
    
    You can manually install the support bundle plugin from the release archives.
    A key advantage this method offers is that it facilitates the installation
    in air gap environments.
    
    Run the following command to download and unarchive the latest release,
    and move the plugin to your ``$PATH``:
    
    ```commandline
    curl -L https://github.com/replicatedhq/troubleshoot/releases/latest/download/support-bundle_linux_amd64.tar.gz | tar xzvf -
    sudo mv ./support-bundle /usr/local/bin/kubectl-support_bundle
        ```
    {{< /tab >}}

{{< /tabs >}}

## Upgrade a support bundle

The instruction for upgrading the support bundle plugin corresponds to the
method that was used to install the plugin. 

{{< tabs items="Krew installation,Manual installation" >}}

    {{< tab >}}
    Run the following krew command to upgrade your existing support-bundle:
   
    ```commandline
    kubectl krew upgrade support-bundle
    ```
    {{< /tab >}}

    {{< tab >}}
    Run the following commands to manually upgrade your existing support-bundle:
    
    1. Download the latest version of the plugin:

    ```commandline
    curl -L https://github.com/replicatedhq/troubleshoot/releases/latest/download/support-bundle_linux_amd64.tar.gz | tar xzvf -
    ```

    2. Replace the existing plugin with the new version:

    ```commandline
    sudo mv ./support-bundle /usr/local/bin/kubectl-support_bundle
    ```

    {{< /tab >}}

{{< /tabs >}}

## Uninstall a support bundle

The instruction for uninstalling the support bundle plugin corresponds to the
method that was used to install the plugin. 

{{< tabs items="Krew installation,Manual installation" >}}

    {{< tab >}}
    Run the following command to remove the support bundle plugin:
    
    ```commandline
    kubectl krew uninstall support-bundle
    ```
    {{< /tab >}}
    {{< tab >}}
    1. Delete the `support-bundle` binary file from where it was placed
      at installation. 
    2. Remove the support bundle:
    
      ```commandline
      sudo rm /usr/local/bin/kubectl-support_bundle
      ```
    {{< /tab >}}
  
{{< /tabs >}}

## Create a support bundle

1. Construct a YAML file to set the support bundle configuration.

    The example ``your-support-bundle.yaml`` file that follows:
    
    - Collects basic information about the cluster.
    - Enumerates all available resources in the cluster.
    - Collects logs from the ``mke-controller-manager`` pods, in the ``logs/`` directory of the output.
    
    ```yaml
    apiVersion: troubleshoot.sh/v1beta2
     kind: SupportBundle
     metadata:
       name: sample
     spec:
       collectors:
         - logs:
             selector:
               - control-plane=controller-manager
             namespace: mke
             name: logs/mke
    ```

2. Generate the support bundle:

    ```commandline
    kubectl support-bundle ./path-to-your-support-bundle.yaml
    ```

   By default, the support bundle collects cluster information and cluster resources.
    
   For a comprehensive list of available in-cluster collectors, refer to the official
   Troubleshoot [All Collectors](https://troubleshoot.sh/docs/collect/all/)
   documentation.

## Collect host information using the k0s-provided YAML file

1. Obtain the [k0s-provided YAML
   file](https://docs.k0sproject.io/stable/support-bundle-worker.yaml).

2. Run the `support-bundle` tool:

    ```shell
    ./support-bundle --kubeconfig /var/lib/k0s/pki/admin.conf <support-bundle-worker.yaml>
    ```

   {{< callout type="info" >}}
     The `support-bundle` tool requires that the `kubeconfig` file be passed as
     an argument. The `kubeconfig` file is located at
     `/var/lib/k0s/pki/admin.conf`.
   {{< /callout >}}

Now, you can find the support bundle with the collected host information at `support-bundle-<timestamp>.tar.gz`.
