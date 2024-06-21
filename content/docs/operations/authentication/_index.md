---
title: Authentication
weight: 1
---

Mirantis Kubernetes Engine (MKE) 4 uses Dex for authentication.
If you want to use a different authentication component, disable
the authentication in the MKE configuration file and add your preferred method.

{{< callout type="warning" >}}
  Be aware that if you opt to use an authentication method other than Dex,
   you will need to undertake all tasks and responsibilities associated with
   configuring and maintaining that method.
{{< /callout >}}

## Prerequisites

- **Identity Provider (IdP):** To set OIDC or SAML you need to configure an IdP with
  an application. Refer to [OIDC](OIDC-providers/OIDC) or [SAML](SAML-providers/SAML)
  for detailed procedures.

- **LDAP Server:** To set LDAP you need to [configure an LDAP server](LDAP) with the users.

## Configuration

You can configure authentication for MKE 4 through the `authentication` section
of the MKE configuration file. `authentication` is enabled by default, however
the settings for each of the individual authentication methods are disabled.
To enable a service, set its `enabled` configuration option to `true`.
Doing so will install the authentication method of your choice on your cluster.

```yaml
authentication:
  enabled: true
```

## Authentication methods

Documentation for specific authentication methods as they apply to MKE 4 is available:

- [OIDC (OpenID Connect)](OIDC-providers/OIDC)
- [SAML (Security Assertion Markup Language)](SAML-providers/SAML)
- [LDAP (Lightweight Directory Access Protocol)](LDAP)
