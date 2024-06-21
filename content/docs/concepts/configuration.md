---
title: Configuration
weight: 2
---

The Mirantis Kubernetes Engine (MKE) 4 configuration file contains an
opinionated configuration on how to set up an MKE cluster.

With the MKE configuration file, you can:

- Define the number of nodes in the cluster.
- Define ways to access the nodes.
- Enable or disable certain MKE components.
- Configure MKE component features

Once set, the MKE configuration file is translated into a more complex
blueprint that contains the granular details on how to set up the cluster.

## Create configuration

1. Generate the default MKE configuration file by running:

    ```commandline
    mkectl init > mke.yaml
    ```

2. Modify the `hosts` section of the MKE configuration file, to apply the
   configuration to a set of pre-existing machines that you have set up in
   advance:

    ```yaml
    hosts:
    - ssh:
        address: 18.224.23.158
        keyPath: "/absolute/path/to/private/key.pem"
        port: 22
        user: root
      role: controller+worker
    - ssh:
        address: 18.224.23.158
        keyPath: "/absolute/path/to/private/key.pem"
        port: 22
        user: ubuntu
      role: worker
    - ssh:
        address: 18.117.87.45
        keyPath: "/absolute/path/to/private/key.pem"
        port: 22
        user: ubuntu
      role: worker
    ```

## Choose addons

A core component of MKE 4 is a default set of curated and tested addons that you
can install by running `mkectl init` and subsequently applying the generated
configuration file.

Using the MKE configuration file, you can enable and disable the MKE 4 addons,
as well as modify their settings. In addition, you can use the
`mkectl init` command with the `--blueprint` option to print the generated
blueprint that reflects your current MKE 4 configuration.

<!-- Discuss with SME NNeisen moving "Create configuration" to "Getting Started" -->
