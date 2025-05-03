---
title: Access and manage the cluster with kubectl
weight: 5
---

{{< callout type="warning" >}} For security purposes, ensure that kubelet is
not accessible from outside of the cluster, as the certificates issued through
the procedures herein can be used to access it. {{< /callout >}}

In addition to the MKE 4k Dashboard, you can access and manage your MKE 4k
cluster using kubectl with a [kubeconfig file](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/).

In MKE 4k, the kubeconfig file provides everything you need, as all of the
necessary certificates are embedded therein. This is counter to MKE 3, which
requires that you download client certificate bundles that contain kubeconfig
files, as well as the certificate files that are required to configure the
Docker CLI.

{{< callout type="info" >}} Currently, only administrators can create
kubeconfig files. As previously created kubeconfig files cannot be viewed or
revoked, the expiration time of the certificates used in the
kubeconfig files must be set appropriately.{{< /callout >}}

The following table illustrates the differences between MKE 4k kubeconfig files
and MKE 3 client bundles:

| Function                                                                                                                                 | <center>MKE 4k<br>kubeconfig files</center> | <center>MKE 3<br>client bundles</center> |
|------------------------------------------------------------------------------------------------------------------------------------------|---------------------------|-------------------------|
| Create by admins for other users                                                                                                         | <center>✅</center>                         | <center>✅</center>                       |
| Create by admins for themselves                                                                                                          | <center>✅</center>                         | <center>✅</center>                       |
| Create by non-admins for other users                                                                                                     | <center>❌</center>                       | <center>❌</center>                       |
| View previously created bundles                                                                                                          | <center>❌</center>                         | <center>✅</center>                       |
| Revoke previously created bundles                                                                                                        | <center>❌</center>                         | <center>✅</center>                       |
| Set expiration time of certificates                                                                                                      | <center>✅</center>                         | <center>❌</center>                       |
| Can be generated from MKE 4k UI                                                                                                             | <center>❌</center>                         | <center>✅</center>                       |
| Non-admin certs are issued by a <br>separate CA that is trusted by <br>kube API server, but not trusted <br>by other components like kubelet | <center>❌</center>                         | <center>✅</center>                       |

## Create a kubeconfig file

{{< callout type="important" >}} Only users with admin permissions can create
kubeconfig files for specific users.{{< /callout >}}

Verify the installation of [OpenSSL](https://github.com/openssl/openssl) and
[kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl).

Use your terminal to run the following procedure from the MKE 4k cluster that you
previously configured with the `mkectl apply` command.

1. Configure the username:

   ```
   USERNAME=<specific-username>
   ```

2. Configure the number of days until expiry:

   ```
   EXPIRES_IN_DAYS=<integer>
   ```

   Be sure to indicate the minimum required number of days at the very least,
   for example `7`, as you cannot later revoke the certificates used by the new
   kubeconfig file.

3. Set the `EXPIRES_IN_SECONDS=` and `KUBECONFIG=` variables. Mirantis
   recommends that you use the settings shown in the following example code block:

   ```
   EXPIRES_IN_SECONDS=$((EXPIRES_IN_DAYS * 24 * 60 * 60))
   KUBECONFIG=~/.mke/mke.kubeconf
   ```

4. Run the following script to generate a kubeconfig file named
   `<username>.kubeconfig`:

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

Once the `<username>.kubeconfig` file is generated, send it to the target user,
who can thereafter use it to access the MKE 4k cluster with the `kubectl --kubeconfig` command.

## List or revoke kubeconfig files

Currently, it is not possible to list or revoke previously created kubeconfig
files in MKE 4k.
