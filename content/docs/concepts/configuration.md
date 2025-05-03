---
title: Configuration
weight: 2
---

The Mirantis Kubernetes Engine (MKE) 4k configuration file contains an
opinionated configuration on how to set up an MKE 4k cluster.

With the `mke4.yaml` configuration file, you can:

- Define the number of nodes in the cluster.
- Define ways to access the nodes.
- Enable or disable certain MKE 4k components.
- Configure MKE 4k component features

Once set, the `mke4.yaml` configuration file is translated into a more complex
[k0rdent template](../k0rdent-templates) that contains the granular details on
how to set up the cluster.

## Create configuration

1. Generate the default `mke4.yaml` configuration file by running:

    ```commandline
    mkectl init > mke4.yaml
    ```

2. Modify the `hosts` section of the `mke4.yaml` configuration file, to apply
   the configuration to a set of pre-existing machines that you have set up in
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

## Choose services

A core component of MKE 4k is a default set of curated and tested services that
you can install by running `mkectl init` and subsequently applying the
generated configuration file.

Using the `mke4.yaml` configuration file, you can enable and disable a number
of the available MKE 4k services, as well as modify the settings of those
services.

<!-- Discuss with SME NNeisen moving "Create configuration" to "Getting Started" -->
