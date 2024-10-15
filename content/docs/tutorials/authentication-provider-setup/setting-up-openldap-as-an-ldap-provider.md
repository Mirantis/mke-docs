---
title: Setting up OpenLDAP as an LDAP provider
weight: 3
---

To create a basic OpenLDAP server to test
[LDAP](../../../../docs/configuration/authentication/ldap) with MKE 4:

{{< callout type="info" >}}
To run the OpenLDAP server you must have [Docker and Docker Compose](https://docs.docker.com/engine/install/) installed on your system.
{{< /callout >}}

1. Create a file called `config-ldap.ldif` with the following content:

   ```ldif
    # dn: dc=example,dc=org
    # objectClass: dcObject
    # objectClass: organization
    # o: Example Company
    # dc: example

    dn: ou=People,dc=example,dc=org
    objectClass: organizationalUnit
    ou: People

    dn: cn=jane,ou=People,dc=example,dc=org
    objectClass: person
    objectClass: inetOrgPerson
    sn: doe
    cn: jane
    mail: janedoe@example.com
    userpassword: foo

    dn: cn=john,ou=People,dc=example,dc=org
    objectClass: person
    objectClass: inetOrgPerson
    sn: doe
    cn: john
    mail: johndoe@example.com
    userpassword: bar

    # Group definitions.

    dn: ou=Groups,dc=example,dc=org
    objectClass: organizationalUnit
    ou: Groups

    dn: cn=admins,ou=Groups,dc=example,dc=org
    objectClass: groupOfNames  dns:
        lameduck:
          enabled: true
          duration: "7s"
    cn: admins
    member: cn=john,ou=People,dc=example,dc=org
    member: cn=jane,ou=People,dc=example,dc=org

    dn: cn=developers,ou=Groups,dc=example,dc=org
    objectClass: groupOfNames
    cn: developers
    member: cn=jane,ou=People,dc=example,dc=org
   ```

   The `config-ldap.ldif` file loads into the Docker container for the LDAP server, from where the server will run the file to create a number of default users.

2. Create a Docker Compose file named `docker-compose.yml` that contains the following content:

   ```yaml
   # For LDAPS with certificate validation:
   # How to extract the TLS certificate from the OpenLDAP container, and encode it for the Dex config (`rootCAData`):
   #   $ docker-compose exec ldap cat /container/run/service/slapd/assets/certs/ca.crt | base64 -w 0
   # But note this issue: https://github.com/osixia/docker-openldap/issues/506

   services:
     ldap:
       image: osixia/openldap:1.4.0
       # Copying is required because the entrypoint modifies the *.ldif files.
       # For verbose output, use:  command: ["--copy-service", "--loglevel", "debug"]
       command: ["--copy-service", "--loglevel", "debug"]
       environment:
         # Required if using LDAPS:
         # Since Dex doesn't use a client TLS certificate, downgrade from "demand" to "try".
         LDAP_TLS_VERIFY_CLIENT: try
       # The hostname is required if using LDAPS with certificate validation.
       # In Dex, use the same hostname (with port) for `connectors[].config.host`.
       #hostname: YOUR-HOSTNAME
       #
       # https://github.com/osixia/docker-openldap#seed-ldap-database-with-ldif
       # Option 1: Add custom seed file -> mount to         /container/service/slapd/assets/config/bootstrap/ldif/custom/
       # Option 2: Overwrite default seed file -> mount to  /container/service/slapd/assets/config/bootstrap/ldif/
       volumes:
         - ./config-ldap.ldif:/container/service/slapd/assets/config/bootstrap/ldif/custom/config-ldap.ldif
       ports:
         - 389:389
         - 636:636
   ```

3. Start the OpenLDAP server:

   ```bash
   docker compose up
   ```

   The Docker Compose file copies in the `config-ldap.ldif` configuration file and uses it to set up the LDAP server, which exposes the LDAP service on port `389` for non-TLS and `636` for TLS.

## Configure MKE to use LDAP

An example MKE4 configuration for LDAP is shown below, for the exemplified LDAP server:

```yaml
authentication:
  enabled: true
  ldap:
    enabled: true
    host: localhost:389
    insecureNoSSL: true
    bindDN: cn=admin,dc=mirantis,dc=org
    bindPW: admin
    usernamePrompt: Email Address
    userSearch:
      baseDN: ou=People,dc=mirantis,dc=org
      filter: "(objectClass=person)"
      username: mail
      idAttr: DN
      emailAttr: mail
      nameAttr: cn
```

Run the `mkectl apply` command using the configuration file to apply the configuration to MKE.

```bash
mkectl apply -f config.yaml
```

## Test authentication flow

1. Navigate to the MKE dashboard: `https://{MKE hostname}`
2. Select **Log in with LDAP** to access the LDAP login page.
3. Enter your credentials and click **Sign In**. If authentication is successful,
   you will be redirected to the MKE dashboard.
