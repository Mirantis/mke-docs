---
title: SAML
weight: 2
---

You can configure SAML (Security Assertion Markup Language) for MKE 4 through
the `authentication.saml` section of the MKE configuration file.

SAML example configuration:

```yaml
authentication:
  saml:
    enabled: true
    ssoURL: https://dev64105006.okta.com/app/dev64105006_mke4saml_1/epkdtszgindywD6mF5s7/sso/saml
    redirectURI: http://www.example.com/dex/callback
    usernameAttr: name
    emailAttr: email
```

## Configure SAML service for MKE

In the MKE configuration file `authentication.saml` section, enable your
SAML service by setting `enabled` to `true`. Use the remaining fields, which
are defined in the following table, to configure your chosen SAML provider.

{{< callout type="info" >}} For information on how to obtain the field values,
refer to [Setting up Okta as a SAML provider](../../../tutorials/authentication-provider-setup/setting-up-okta-as-a-saml-provider).
{{< /callout >}}

| Field                             | Description                                                                                                                                                                                                |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `enabled`                         | Enable authentication through dex.                                                                                                                                                                         |
| `ssoMetadataURL`                  | Metadata URL provided by some IdPs, with which MKE can retrieve information for all other SAML configurations.<br><br>When a URL is provided for `ssoMetadataURL`, the other SAML fields are not required. |
| `ca`                              | Certificate Authority (CA) alternative to `caData` to use when validating the signature of the SAML response. Must be manually mounted in a local accessible by dex.                                       |
| `caData`                          | CA alternative to `ca`, which you can use to place the certificate data directly into the config file.                                                                                                     |
| `ssoURL`                          | URL to provide to users to sign into MKE 4 with SAML. Provided by the IdP.                                                                                                                                 |
| `redirectURI`                     | Callback URL for dex to which users are returned to following successful IdP authentication.                                                                                                               |
| `insecureSkipSignatureValidation` | Optional. Use to skip the signature validation. For testing purposes only.                                                                                                                                 |
| `usernameAttr`                    | Username attribute in the returned assertions, to map to ID token claims.                                                                                                                                  |
| `emailAttr`                       | Email attribute in the returned assertions, to map to ID token claims.                                                                                                                                     |
| `groupsAttr`                      | Optional. Groups attribute in the returned assertions, to map to ID token claims.                                                                                                                          |
| `entityIssuer`                    | Optional. Include as the Issuer value during authentication requests.                                                                                                                                      |
| `ssoIssuer`                       | Optional. Issuer value that is expected in the SAML response.                                                                                                                                              |
| `groupsDelim`                     | Optional. If groups are assumed to be represented as a single attribute, this delimiter splits the attribute value into multiple groups.                                                                   |
| `nameIDPolicyFormat`              | Requested name ID format.                                                                                                                                                                                  |

## Test authentication flow

1. Navigate to `http://{MKE hostname}/dex/login`.
2. Click **Login** to display the login page.
3. Select **Log in with SAML**.
4. Enter your credentials and click **Sign In**. If authentication is successful,
   you will be redirected to the client applications home page.
