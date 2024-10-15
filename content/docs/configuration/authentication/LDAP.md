---
title: LDAP
weight: 3
---

You can configure LDAP (Lightweight Directory Access Protocol) for MKE 4 through
the `authentication.ldap` section of the MKE configuration file.

LDAP example configuration:

```yaml
authentication:
  enabled: true
  ldap:
    enabled: true
    host: ldap.example.org:389
    insecureNoSSL: true
    bindDN: cn=admin,dc=example,dc=org
    bindPW: admin
    usernamePrompt: Email Address
    userSearch:
      baseDN: ou=People,dc=example,dc=org
      filter: "(objectClass=person)"
      username: mail
      idAttr: DN
      emailAttr: mail
      nameAttr: cn
```

## Configure LDAP service for MKE

In the MKE configuration file `authentication.ldap` section, enable your
LDAP service by setting `enabled` to `true`. Use the remaining fields, which
are defined in the following table, to configure
the interactions with your LDAP server.

{{< callout type="info" >}}
For information on how to obtain the field values, refer to [setting up OpenLDAP as an LDAP provider](../../../tutorials/authentication-provider-setup/setting-up-openldap-as-an-ldap-provider).
{{< /callout >}}

| Field                              | Description                                                           |
| ---------------------------------- | --------------------------------------------------------------------- |
| `host`                             | Host and optional port of the LDAP server, in the `host:port` format. |
| `rootCA`                           | Path to a trusted root certificate file.                              |
| `bindDN`                           | Distinguished Name (DN) for an application service account.           |
| `bindPW`                           | Password for an application service account.                          |
| `usernamePrompt`                   | Attribute to display in the password prompt.                          |
| `userSearch`                       | Settings to map user-entered username and password to an LDAP entry.  |
| `userSearch.baseDN`                | BaseDN from which to start the search.                                |
| `userSearch.filter`                | Optional filter to apply for a user search of the directory.          |
| `userSearch.username`              | Username attribute to use for user entry comparison.                  |
| `userSearch.idAttr`                | String representation of the user.                                    |
| `userSearch.emailAttr`             | Attribute to map to email.                                            |
| `userSearch.nameAttr`              | Attribute to map to display name of a user.                           |
| `userSearch.preferredUsernameAttr` | Attribute to map to preferred usernames.                              |
| `groupSearch`                      | Group search queries for groups given a user entry.                   |
| `groupSearch.baseDN`               | BaseDN from which to start the search.                                |
| `groupSearch.filter`               | Optional filter to apply for a group search of the directory.         |
| `groupSearch.userMatchers`         | Field pairs list to use to match a user to a group.                   |
| `groupSearch.nameAttr`             | Group name.                                                           |

For more information, refer to the official DEX documentation
[LDAP configuration](https://dexidp.io/docs/connectors/ldap/#configuration).
