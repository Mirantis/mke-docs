---
title: kubectl
weight: 5
---

<!-- For discussion: Need to decide if this is a proper placement for the topic, or if it should be bundled up with the MKE Dashboard topic under a "Access and manage the cluster" top level topic, or some other solution. -->

{{< callout type="warning" >}} For security purposes, ensure that kubelet is
not accessible from outside of the cluster, as the certificates issued through
the procedures herein can be used to access it. {{< /callout >}}

In addition to the MKE Dashboard, you can access and manipulate your MKE 4
cluster using kubectl with a [kubeconfig file](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/).

In MKE 4, the kubeconfig file provides everything you need, as all of the
necessary certificates are embedded therein. This is counter to MKE 3, which
requires that you download client certificate bundles that contain kubeconfig
files, as well as the certificate files that are required to configure the
Docker CLI.

{{< callout type="info" >}} Currently, only administrators can create
kubeconfig files. As previously created kubeconfig files cannot be viewed or
revoked, the expiration time of the certificates used in the
kubeconfig files must be set appropriately.{{< /callout >}}

The following table illustrates the differences between MKE 4 kubeconfig files
and MKE 3 client bundles:

| Function                                                                                                                                 | <center>MKE 4<br>kubeconfig files</center> | <center>MKE 3<br>client bundles</center> |
|------------------------------------------------------------------------------------------------------------------------------------------|---------------------------|-------------------------|
| Create by admins for other users                                                                                                         | <center>✅</center>                         | <center>✅</center>                       |
| Create by admins for themselves                                                                                                          | <center>✅</center>                         | <center>✅</center>                       |
| Create by non-admins for other users                                                                                                     | <center>❌</center>                       | <center>❌</center>                       |
| Create by non-admins for themselves                                                                                                      | <center>✅</center>                         | <center>❌</center>                       |
| View previously created bundles                                                                                                          | <center>✅</center>                         | <center>❌</center>                       |
| Revoke previously created bundles                                                                                                        | <center>✅</center>                         | <center>❌</center>                       |
| Set expiration time of certificates                                                                                                      | <center>❌</center>                         | <center>✅</center>                       |
| Can be generated from MKE UI                                                                                                             | <center>✅</center>                         | <center>❌</center>                       |
| Non-admin certs are issued by a <br>separate CA that is trusted by <br>kube API server, but not trusted <br>by other components like kubelet | <center>✅</center>                         | <center>❌</center>                       |

## Create a kubeconfig file

{{< callout type="important" >}} Only users with admin permissions can create
kubeconfig files for specific users.{{< /callout >}}

Run the procedure following procedure from the MKE 4 cluster that you
previously configured with the `mkectl apply` command.

<!-- How does this fit in here: "Alternatively, you can run
the script if another admin previously issued you a kubeconfig file with admin-level permissions." -->

1. Verify the installation of [openssl](https://github.com/openssl/openssl) and
   [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl).

2. Set the following variables:

   <!-- Text is needed to touch up on how the user sets these variables. Here we just say "Do it!" without any mention of the process. It may be second-nature to the user, but we still have to indicate how it is done. -->

   * `USERNAME=`
   * `EXPIRES_IN_DAYS=`

   By default, `EXPIRES_IN_DAYS=` is set to `7`. If you change the default
   value, make sure it is set to a reasonable value as it is not possible to
   later revoke the certificates used by the new kubeconfig file.

   <!--Is this a default value that is pre-set, or is it the value that we are suggesting be set? -->

   {{< callout type="info" >}} The value for the `EXPIRES_IN_SECONDS=` variable
   is automatically calculated as ((EXPIRES_IN_DAYS * 24 * 60 * 60)), and the
   `KUBECONFIG=` variable is set by default to the MKE 4 clusters location that
   was created by the `mkectl apply` command at cluster creation. {{< /callout >}}

3. Run the following command sequence to generate a kubeconfig file in the
   `<username>.kubeconfig` directory.

   ```
   export KUBECONFIG

   openssl genrsa -out $USERNAME.key 2048
   openssl req -new -key $USERNAME.key -out $USERNAME.csr -subj "/CN=$USERNAME"

   CSR_CONTENT=$(cat $USERNAME.csr | base64 | tr -d '\n')
   CSR_NAME=$USERNAME-csr-$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 10; echo)

   cat <<EOF | envsubst | kubectl apply -f -
   apiVersion: certificates.k8s.io/v1
   kind: CertificateSigningRequest
   metadata:
     name: $CSR_NAME
   spec:
     request: $CSR_CONTENT
     signerName: kubernetes.io/kube-apiserver-client
     expirationSeconds: $EXPIRES_IN_SECONDS
     usages:
     - client auth
   EOF

   kubectl certificate approve "$CSR_NAME"
   kubectl get csr "$CSR_NAME" -o jsonpath='{.status.certificate}' | base64 --decode > $USERNAME.crt

   kubectl config view --minify --flatten > $USERNAME.kubeconfig
   kubectl config unset users --kubeconfig=$USERNAME.kubeconfig > /dev/null
   kubectl config unset contexts --kubeconfig=$USERNAME.kubeconfig > /dev/null

   kubectl config set-credentials $USERNAME --client-certificate=$USERNAME.crt --client-key=$USERNAME.key --embed-certs=true --kubeconfig=$USERNAME.kubeconfig
   kubectl config set-context mke-$USERNAME --cluster=mke --user=$USERNAME --kubeconfig=$USERNAME.kubeconfig
   kubectl config use-context mke-$USERNAME --kubeconfig=$USERNAME.kubeconfig

   rm $USERNAME.crt $USERNAME.csr $USERNAME.key
   ```

4. Send the generated `<username>.kubeconfig` file to the target user, who
   can thereafter use it to access the MKE 4 cluster with the `kubectl
   --kubeconfig` command.

## List or revoke kubeconfig files

Currently, it is not possible to list or revoke previously created kubeconfig
files in MKE 4.