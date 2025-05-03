---
title: Authentication
weight: 1
---

MKE 4k uses [Dex](https://dexidp.io/) for authentication. Dex serves as a proxy
between your MKE 4k cluster and your authentication providers, combining the
configuration of multiple authentication providers into a single configuration
while also handling the complexity of the various protocols.

Mirantis Kubernetes Engine (MKE) 4k supports the following authentication
protocols:

- OpenID Connect (OIDC)
- Security Assertion Markup Language (SAML)
- Lightweight Directory Access Protocol (LDAP)

## Prerequisites

You must have certain dependencies in place before you can configure
authentication. These dependencies differ, depending on which authentication
protocol you choose to deploy.

- **Identity Provider (IdP):** To use OIDC or SAML, you must configure an identity provider. For examples of how to use Okta as an authentication service provider for either of these protocols, refer to [OIDC](../../configuration/authentication/oidc) or [SAML](../../configuration/authentication/saml).

- **LDAP Server:** To use LDAP, you must have an LDAP server configured. A setup example for an OpenLDAP server is available at [LDAP](../../configuration/authentication/ldap).

## Configuration

You configure authentication for MKE 4k through the `authentication` section
of the `mke4.yaml` configuration file.

Authentication is always enabled, however, the settings for each of the
individual authentication protocols are disabled. To enable and install an
authentication protocol, set its `enabled` configuration option to `true`.

```yaml
authentication:
  ldap:
    enabled: false
  oidc:
    enabled: false
  saml:
    enabled: false
```

## Set Expiration

You can use the `expiry` section of the configuration file to set the expiration time for refresh and id tokens, in the format of number + time unit format. For example, `1h` to designate one hour.

```yaml
authentication:
  expiry:
    refreshTokens: {}
```

The following table shows all of the available fields for the `expiry` section.

| Field                                    | Description                                                              |
| ---------------------------------------- | ------------------------------------------------------------------------ |
| `expiry`                                 | Section for the various expiry settings.                                 |
| `expiry.idTokens`                        | Lifetime of the ID tokens.                                               |
| `expiry.authRequests`                    | Time frame that a code can be exchanged for a token.                     |
| `expiry.deviceRequests`                  | Time frame in which users can authorize a device to receive a token.     |
| `expiry.signingKeys`                     | Time period after which the signing keys are rotated.                    |
| `expiry.refreshTokens`                   | Section for the various refresh token settings.                          |
| `expiry.refreshTokens.validIfNotUsedFor` | Invalidate a refresh token if it is not used for the specified time.     |
| `expiry.refreshTokens.absoluteLifetime`  | Absolute time frame of a refresh token.                                  |
| `expiry.refreshTokens.disableRotation`   | Disable every-request rotation.                                          |
| `expiry.refreshTokens.reuseInterval`     | Interval for obtaining the same refresh token from the refresh endpoint. |

## Unsupported functions

Authentication functions that are not supported in MKE 4k include:

* OIDC proxies
* SAML proxies
* LDAP disablement of referral chasing
* LDAP JIT provisioning
* LDAP SAML logins
* LDAP simple pagination
* LDAP user sync
* MFA (Multi-Factor Authentication)
