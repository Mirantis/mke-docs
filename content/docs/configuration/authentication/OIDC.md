---
title: OIDC
weight: 2
---

You configure OIDC (OpenID Connect) for MKE 4k through the `authentication.oidc`
section of the `mke4.yaml` configuration file.

OIDC example configuration:

```yaml
authentication:
  oidc:
    enabled: true
    issuer: https://dev-94406016.okta.com
    clientID: 0oedtjcjrjWab3zlD5d4
    clientSecret: DFA9NYLfE1QxwCSFkZunssh2HCx16kDl41k9tIBtFZaNcqyEGle8yZPtMBesyomD
```

## Configure OIDC service for MKE

In the `mke4.yaml` configuration file `authentication.oidc` section, enable your
OIDC service by setting `enabled` to `true`. Use the remaining fields, which
are defined in the following table, to configure your chosen OIDC provider.

{{< callout type="info" >}}
For information on how to obtain the field values, refer to [Setting up Okta as an OIDC provider](../../../tutorials/authentication-provider-setup/setting-up-okta-as-an-oidc-provider).
{{< /callout >}}

| Field          | Description                                                          |
| -------------- | -------------------------------------------------------------------- |
| `issuer`       | OIDC provider root URL.                                              |
| `clientID`     | ID from the IdP application configuration.                           |
| `clientSecret` | Secret from the IdP application configuration.                       |

For more information, refer to the official DEX documentation
[OIDC configuration](https://dexidp.io/docs/connectors/oidc/#configuration).
