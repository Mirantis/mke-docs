---
title: SAML
weight: 3
---

You can configure SAML (Security Assertion Markup Language) for MKE 4 through
the `authentication` section of the MKE configuration file.
To enable the service, set `enabled` to `true`.
The remaining fields in the `authentication.saml` section are used to configure
the SAML provider. 
For information on how to obtain the field values, refer to your chosen provider:

- [Okta](SAML-OKTA-configuration)

For more information, refer to the official DEX documentation
[Authentication through SAML 2.0](https://dexidp.io/docs/connectors/saml/).

## Configure MKE

The MKE configuration file `authentication.smal` fields are detailed below:

| Field                             | Description                                                                                                                                                                         |
|-----------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `enabled`                         | Enable authentication through dex.                                                                                                                                                  |
| `ssoMetadataURL`                  | Metadata URL provided by some IdPs, with which MKE can retrieve information for all other SAML configurations.                                                                      |
| `ca`                              | Certificate Authority (CA) alternative to `caData` and `localCa`, to use when validating the signature of the SAML response. Must be manually mounted in a local accessible by dex. |
| `caData`                          | CA alternative to `ca` and `localCa`, which you can use to place the certificate data directly into the config file.                                                                |
| `localCa`                         | Alternative to `ca` and `caData`. A path to a CA file in the local system, with which MKE mounts and creates a secret for the certificate.                                          |
| `ssoURL`                          | URL to provide to users to sign into MKE 4 with SAML. Provided by the IdP.                                                                                                          |
| `redirectURI`                     | Callback URL for dex to which users are returned to following successful IdP authentication.                                                                                        |
| `insecureSkipSignatureValidation` | Optional. Use to skip the signature validation. For testing purposes only.                                                                                                          |
| `usernameAttr`                    | Username attribute in the returned assertions, to map to ID token claims.                                                                                                           |
| `emailAttr`                       | Email attribute in the returned assertions, to map to ID token claims.                                                                                                              |
| `groupsAttr`                      | Optional. Groups attribute in the returned assertions, to map to ID token claims.                                                                                                   |
| `entityIssuer`                    | Optional. Include as the Issuer value during authentication requests.                                                                                                               |
| `ssoIssuer`                       | Optional. Issuer value that is expected in the SAML response.                                                                                                                       |
| `groupsDelim`                     | Optional. If groups are assumed to be represented as a single attribute, this delimiter splits the attribute value into multiple groups.                                            |
| `nameIDPolicyFormat`              | Requested name ID format.                                                                                                                                                           |

An example configuration for SAML:

```yaml
authentication:
  enabled: true
  saml:
    enabled: true
    ssoURL: https://dev64105006.okta.com/app/dev64105006_mke4saml_1/epkdtszgindywD6mF5s7/sso/saml
    redirectURI: http://{MKE host}:5556/callback
    localCa: /etc/ssl/okta.cert
    usernameAttr: name
    emailAttr: email
```

## Test authentication flow

{{< callout type="info" >}}
  To test authentication flow, ports `5556` (dex) and `5555` (example-app) must be externally available.
{{< /callout >}}

1. Navigate to `http://{MKE hostname}:5555/login`.
2. Click **Login** to display the login page.
3. Select **Log in with SAML**.
4. Enter your credentials and click **Sign In**. If authentication is successful,
you will be redirected to the client applications home page.
