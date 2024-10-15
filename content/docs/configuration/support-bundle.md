---
title: Support bundle
weight: 4
---

For the Alpha.1 release, MKE 4 deploys k0s v1.29.3, which does not inherently
support the [Replicated support bundle
tool](https://troubleshoot.sh/docs/support-bundle/introduction/).

## Manually collect a support bundle

1. SSH into the manager node.
2. Download and install the `support-bundle` tool:

   ```shell
   curl -L https://github.com/replicatedhq/troubleshoot/releases/latest/download/support-bundle_linux_amd64.tar.gz | tar xzvf -
   ```
3. Create a YAML file that details the support bundle configuration.

   Example `support-bundle-worker.yaml` file:

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

     This configuration accomplishes the following:

     - Captures of cluster information
     - Sets of cluster resources
     - Collects logs from the `blueprint-controller-manager` and
       `blueprint-operator-webhook` pods, in the `logs/` directory of the
       output.

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
