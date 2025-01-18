---
title: TLS certificates
weight: 10
---

To ensure all communications between clients and MKE are encrypted, MKE
services are exposed using HTTPS. By default, this is done using self-signed
TLS certificates that are not trusted by client tools such as web browsers.
Thus, when you try to access MKE, your browser warns that it does not trust MKE
or that MKE has an invalid certificate.

You can configure MKE to use your own TLS certificates. As a result, your
browser and other client tools will trust your MKE installation.

Mirantis recommends that you make TLS certificate changes outside of peak business hours.
Your applications will continue to run normally. However, the Ingress
Controller will restart, and applications exposed through it may experience a
short period of unavailability.

## Use the MKE web UI to align TLS artifacts

To configure MKE with the MKE web UI to use your own TLS certificates and keys:

1. Log in to the MKE web UI as an administrator.

2. In the left-side navigation panel, navigate to **Admin Settings** > **Certificates**.

3. Upload your certificates and keys.

    {{< callout type="info" >}}
    All keys and certificates must be uploaded in PEM format, and the
    certificates must include the following SANs:
    - external IP address
    - IP addresses for all manager nodes

      To obtain the list of all required hosts, run the following command from
      the directory that contains the `mke4.yaml` file:

      ```bash
      HOSTS=$(yq '[(.spec.apiServer.externalAddress, .spec.hosts.[] | select(.role == "controller+worker") | .ssh.address)] | join(" ")' mke4.yaml)
      echo $HOSTS
      ```
    {{< /callout >}}
    
    | Type               | Description   |
    |--------------------|---------------|
    | Private key        | The unencrypted private key for MKE. This key must correspond to the public key used in the server certificate. This key does not use a password.<br/><br/>Click **Upload Key** to upload a PEM file.                                                       |
    | Server certificate | The MKE public key certificate, which establishes a chain of trust up to the root CA certificate. It is followed by the certificates of any intermediate certificate authorities.<br/><br/>Click **Upload Certificate** to upload a PEM file.               |
    | CA certificate     | The public key certificate of the root certificate authority that issued the MKE server certificate. If you do not have a CA certificate, use the top-most intermediate certificate instead.<br/><br/>Click **Upload CA Certificate** to upload a PEM file. |

4. Click **Save**.

## Use the CLI to align TLS artifacts

To configure MKE with the CLI to use your own TLS certificates and keys:

1. All keys and certificates must be uploaded in PEM format, and the
   certificates must include the following SANs:
   - external IP address
   - IP addresses for all manager nodes

     To obtain the list of all required hosts, run the following command from
     the directory that contains the `mke4.yaml` file:

     ```bash
     HOSTS=$(yq '[(.spec.apiServer.externalAddress, .spec.hosts.[] | select(.role == "controller+worker") | .ssh.address)] | join(" ")' mke4.yaml)
     echo $HOSTS
     ```
   
2. Encode certificate material.

   **MacOS:**

   ```bash
   CA_CERT=$(cat ca.pem | base64 -b0)
   SERVER_CERT=$(cat cert.pem | base64 -b0)
   SERVER_KEY=$(cat key.pem | base64 -b0)
   ```

   **Linux:**

   ```bash
   CA_CERT=$(cat ca.pem | base64 -w0)
   SERVER_CERT=$(cat cert.pem | base64 -w0)
   SERVER_KEY=$(cat key.pem | base64 -w0)
   ```

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
   Controller to the previously established secret name.

   ```bash
   yq -i '.spec.ingressController.extraArgs.defaultSslCertificate = "mke/user-provided-ingress-cert"' mke4.yaml
   ```

   Example MKE configuration file `ingressController` section:
    
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
