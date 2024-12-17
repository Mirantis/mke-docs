---
title: Use an MKE configuration file
weight: 1
---

Put the MKE configuration file to work for the following use cases:

-   Set the configuration file to run at the install time of new MKE
    clusters
-   Use the API to import the file back into the same cluster
-   Use the API to import the file into multiple clusters

To make use of an MKE configuration file, you edit the file using either
the MKE web UI or the command line interface (CLI). Using the CLI, you
can either export the existing configuration file for editing, or use
the `example-config`{.interpreted-text role="command"} command to view
and edit an example TOML MKE configuration file.

``` bash
docker container run --rm
  -v /var/run/docker.sock:/var/run/docker.sock \
  {{ page.ucp_org }}/{{ page.ucp_repo }}:{{ page.ucp_version }} \ example-config
```

## Modify an existing MKE configuration

Working as an MKE admin, use the `config-toml` API from within the
directory of your client certificate bundle to export the current MKE
settings to a TOML file.

As detailed herein, the command set exports the current configuration
for the MKE hostname `MKE_HOST` to a file named `mke-config.toml`:

1.  Define the following environment variables:

    ``` bash
    export MKE_USERNAME=<mke-username>
    export MKE_PASSWORD=<mke-password>
    export MKE_HOST=<mke-fqdm-or-ip-address>
    ```

2.  Obtain and define an `AUTHTOKEN` environment variable:

    ``` bash
    AUTHTOKEN=$(curl --silent --insecure --data '{"username":"'$MKE_USERNAME'","password":"'$MKE_PASSWORD'"}' https://$MKE_HOST/auth/login | jq --raw-output .auth_token)
    ```

3.  Download the current MKE configuration file.

    ``` bash
    curl --silent --insecure -X GET "https://$MKE_HOST/api/ucp/config-toml" -H "accept: application/toml" -H "Authorization: Bearer $AUTHTOKEN" > mke-config.toml
    ```

4.  Edit the MKE configuration file, as needed. For comprehensive
    detail, refer to `configuration-options`{.interpreted-text
    role="ref"}.

5.  Upload the newly edited MKE configuration file:

    {{< callout type="info" >}} You may need to reacquire the `AUTHTOKEN`, if
    significant time has passed since you first acquired it.
    {{< /callout >}}

    ``` bash
    curl --silent --insecure -X PUT -H "accept: application/toml" -H "Authorization: Bearer $AUTHTOKEN" --upload-file 'mke-config.toml' https://$MKE_HOST/api/ucp/config-toml
    ```

## Apply an existing configuration at install time

To customize a new MKE instance using a configuration file, you must
create the file prior to installation. Then, once the new configuration
file is ready, you can configure MKE to import it during the
installation process using Docker Swarm.

**To import a configuration file at installation:**

1.  Create a Docker Swarm Config object named `com.docker.mke.config`
    and the TOML value of your MKE configuration file contents.
2.  When installing MKE on the cluster, specify the `--existing-config`
    flag to force the installer to use the new Docker Swarm Config
    object for its initial configuration.
3.  Following the installation, delete the `com.docker.mke.config`
    object.
