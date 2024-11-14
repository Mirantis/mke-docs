---
title: Support bundle
weight: 4
---

The support bundle plugin, a kubectl extension, is required to generate support
bundles directly from the command line.

## Install the support bundle

You can install the support bundle plugin using Krew plugin manager or manually
from the release archives.

{{< tabs items="Install using Krew,Install manually" >}}

    {{< tab >}}
    1. Install the support bundle plugin.
       Follow the steps based on whether you have the Krew plugin manager installed:

       - To install both Krew and the support bundle plugin in one step, run:

       ```commandline
       curl https://krew.sh/support-bundle | bash
       ```
       Next, skip to step 3, as the installation command automatically adds the
       plugin path to your ``PATH`` environment variable.

       - If Krew is already installed, install the support bundle plugin with:
        
       ```commandline
       kubectl krew install support-bundle
       ```

    2. Append the ``$HOME/.krew/bin`` directory to your ``PATH`` environment variable:

       ```commandline
       export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
       ```

    3. Restart your shell and run ``kubectl krew`` to verify the installation.
    
    {{< /tab >}}
    
    {{< tab >}}
    
    If you do not want to install the plugin using Krew or want a simpler
    way to install the plugin in an air gap environment, you can install the
    plugin manually from the release archives.
    
    Run the following command to download and unarchive the latest release,
    and move the plugin to your ``$PATH``:
    
    ```commandline
    curl -L https://github.com/replicatedhq/troubleshoot/releases/latest/download/support-bundle_linux_amd64.tar.gz | tar xzvf -
    sudo mv ./support-bundle /usr/local/bin/kubectl-support_bundle
        ```
    {{< /tab >}}

{{< /tabs >}}

## Upgrade support bundle using Krew

To upgrade your existing support-bundle plugin using Krew run:

```commandline
kubectl krew upgrade support-bundle
```

## Uninstall support bundle

Choose the method used during a plugin installation process, and follow the
steps to uninstall the support bundle:

{{< tabs items="Uninstall using Krew,Uninstall manually" >}}

    {{< tab >}}
    Run the following command to remove the support bundle plugin:
    
    ```commandline
    kubectl krew uninstall support-bundle
    ```
    {{< /tab >}}
    {{< tab >}}
    1. Delete the support-bundle binary file from the location where it was placed
      during installation. 
    2. Run the following command to remove the support bundle:
    
      ```commandline
      sudo rm /usr/local/bin/kubectl-support_bundle
      ```
    {{< /tab >}}
  
{{< /tabs >}}

## Define data for collecting

1. Define what the support bundle should collect and, optionally, analyze,
   by creating a YAML file that outlines the support bundle configuration

    The following example configuration:
    
    - Captures cluster information.
    - Sets of cluster resources.
    - Collects logs from the ``blueprint-controller-manager`` and
      ``blueprint-operator-webhook`` pods, in the ``logs/`` directory of the output.
    
    Example ``support-bundle-worker.yaml`` file:
    
    ```yaml
      apiVersion: troubleshoot.sh/v1beta2
      kind: SupportBundle
      metadata:
        name: sample
      spec:
        collectors:
          - logs:
              selector:
                - app.kubernetes.io/name=blueprint-webhook
            namespace: blueprint-system
            name: logs/blueprint-system
          - logs:
              selector:
                - control-plane=controller-manager
              namespace: blueprint-system
              name: logs/blueprint-system
    ```

2. Generate the support bundle by pointing to your specification file using
   the following command:

    ```commandline
    kubectl support-bundle ./path-to-your-support-bundle.yaml
    ```

   By default, it collects cluster information and cluster resources.
    
   For a full list of available in-cluster collectors, refer to the
   [All Collectors](https://troubleshoot.sh/docs/collect/all/)
   in the official Troubleshoot documentation.

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
