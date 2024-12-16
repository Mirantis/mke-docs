---
title: TLS certificates
weight: 10
---

To ensure all communications between clients and MKE are encrypted, all MKE
services are exposed using HTTPS. By default, this is done using self-signed
TLS certificates that are not trusted by client tools such as web browsers.
Thus, when you try to access MKE, your browser warns that it does not trust MKE
or that MKE has an invalid certificate.

You can configure MKE to use your own TLS certificates. As a result, your
browser and other client tools will trust your MKE installation.

Mirantis recommends that you make this change outside of peak business hours.
Your applications will continue to run normally, but existing MKE client
certificates will become invalid, and thus users will have to download new
certificates to access MKE from the CLI.

## Set TLS certificate using MKE web UI

1. Log in to the MKE web UI as an administrator.

2. In the left-side navigation panel, navigate to your **Username** >
   **Admin Settings** > **Certificates**.

3. Upload your certificates and keys based on the following table.

    {{< callout type="info" >}}
    All keys and certificates must be uploaded in PEM format.
    {{< /callout >}}
    
    | Type               | Description   |
    |--------------------|---------------|
    | Private key        | The unencrypted private key for MKE. This key must correspond to the public key used in the server certificate. This key does not use a password.<br/><br/>Click **Upload Key** to upload a PEM file.                                                       |
    | Server certificate | The MKE public key certificate, which establishes a chain of trust up to the root CA certificate. It is followed by the certificates of any intermediate certificate authorities.<br/><br/>Click **Upload Certificate** to upload a PEM file.               |
    | CA certificate     | The public key certificate of the root certificate authority that issued the MKE server certificate. If you do not have a CA certificate, use the top-most intermediate certificate instead.<br/><br/>Click **Upload CA Certificate** to upload a PEM file. |

4. Click **Save**.

After replacing the TLS certificates, users cannot authenticate with their old
client certificate bundles. Instruct users to access the MKE web UI and
download new client certificate bundles.

## Set TLS certificate using CLI

To set up the certificate with commandline and `mkectl`:

1. Create a new TLS certificate and key signed by a trusted CA.

   It must include:
   - the external address
   - the IP addresses of all manager nodes in the list of allowed hosts

   To get the list of all required hosts, run the following command:

   ```bash
   HOSTS=$(yq '[(.spec.apiServer.externalAddress, .spec.hosts.[] | select(.role == "controller+worker") | .ssh.address)] | join(" ")' <MKE CONFIGURATION FILE NAME>)
   echo $HOSTS
   ```


2. Encode certificate material:

   ```bash
   CA_CERT=$(cat ca.pem | base64 -b0)
   SERVER_CERT=$(cat cert.pem | base64 -b0)
   SERVER_KEY=$(cat key.pem | base64 -b0)
   ```

   If you are using Linux, use `base64 -w0` instead.

3. Create a secret with the new certificate material:

   ```bash
   cat <<EOF | envsubst '$CA_CERT $SERVER_CERT $SERVER_KEY' | kubectl apply -f -
   apiVersion: v1
   kind: Secret
   metadata:
     name: <USER-PROVIDED-INGRESS-CERT>  # name can be anything
     namespace: mke  # namespace MUST be mke
   data:
     ca.crt: $CA_CERT
     tls.crt: $SERVER_CERT
     tls.key: $SERVER_KEY
   EOF
   ```

4. In the configuration, set the `defaultSslCertificate` of the Ingress
   Controller to the secret name from a previous step.

   ```bash
   yq -i '.spec.ingressController.extraArgs.defaultSslCertificate = "mke/<USER-PROVIDED-INGRESS-CERT>"' <MKE CONFIGURATION FILE NAME>
   ```

   Example Ingress Controller section in the MKE configuration file:
    
   ```yaml
   spec:
     ingressController:
       extraArgs:
         defaultSslCertificate: mke/<USER-PROVIDED-INGRESS-CERT> 
   ```

5. Apply the configuration:

   ```bash
   mkectl apply
   ```