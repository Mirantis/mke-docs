---
title: OIDC
weight: 1
---

You can configure OIDC (OpenID Connect) for MKE 4 through the `authentication`
section of the MKE configuration file. To enable the service, set `enabled` to `true`.
The remaining fields in the `authentication.oidc` section are used to configure
the OIDC provider.

For information on how to obtain the field values, refer to your chosen provider:

- [Okta](OIDC-OKTA-configuration)

## Configure MKE

The MKE configuration file `authentication.oidc` fields are detailed below:

| Field          | Description                                                       |
|----------------|-------------------------------------------------------------------|
| `issuer`       | OIDC provider root URL.                                           |
| `clientID`     | ID from the IdP application configuration.                        |
| `clientSecret` | Secret from the IdP application configuration.                    |
| `redirect URI` | URI to which the provider will return successful authentications. |

OIDC example configuration:

```yaml
authentication:
  enabled: true
  oidc:
    enabled: true
    issuer: https://dev-94406016.okta.com
    clientID: 0oedtjcjrjWab3zlD5d4
    clientSecret: DFA9NYLfE1QxwCSFkZunssh2HCx16kDl41k9tIBtFZaNcqyEGle8yZPtMBesyomD
    redirectURI: http://dex.example.com:32000/callback
```

## Test authentication flow

{{< callout type="info" >}}
  To test authentication flow, ports `5556` (dex) and `5555` (example-app) must be externally available. 
{{< /callout >}}

1. Navigate to `http://{MKE hostname}:5555/login`
2. Click **Login** to display the login page.
3. Select **Log in with OIDC**.
4. Enter your credentials and click **Sign In**. If authentication is successful,
you will be redirected to the client applications home page.
