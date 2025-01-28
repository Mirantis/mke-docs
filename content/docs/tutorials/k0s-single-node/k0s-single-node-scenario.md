---
title: Create a Kubernetes cluster in single node and install MKE
weight: 1
---

This tutorial provides the most simple setup for testing purposes or any very compact deployment. 

{{< callout type="info" >}}

This should not be used in production! 
{{< /callout >}}

## Prerequisites
In addition to the MKE [dependencies](../../../getting-started/install-mke-cli) and MKE [System requirements](../../../getting-started/system-requirements)
you need to do the following:
- Provide a virtual machine locally or on any provider with an accessible IP 
- Open ports (at least):
  - 80 (HTTP)
  - 443 (HTTPs)
  - 6443 (Kubernetes API)
  - 22 (SSH)
- Configure SSH access via SSH-key

{{< callout type="info" >}}
This can be automated with any tool you're familar with eq.: Terraform, Ansible etc.

{{< /callout >}}

## Install MKE on k0s

1. Generate a sample `mke4.yaml` file:

   ```shell
   mkectl init > mke4.yaml
   ```

2. Edit the `hosts` section in `mke4.yaml`. 
   Example configuration of the `hosts` section:

    ```yaml
    hosts:
     - role: single #This identifies it's just a single VM
       ssh:
         address: <IP of your VM>
         keyPath: <full path to your SSH private key> 
         port: 22
         user: ubuntu #If you use Ubuntu for your VM this is the default user
    ```
3. Edit the `apiServer` section in the configuration file (mke4.yml) and add externalAddress and sans. \
   The **externalAddress** should be the public/floating IP of the node and the **sans** should contain all IP addresses you want to connect with, this is required to generate the correct certificate.
    ```yaml
    apiServer:
      externalAddress: "<external IP of the VM>"
      sans: ["external IP of the VM"]
      audit:
        enabled: false
        logPath: /var/log/mke4_audit.log
        maxAge: 30
        maxBackup: 10
        maxSize: 10
      encryptionProvider: /var/lib/k0s/encryption.cfg
    ```
    If you get later an SSL issue in regards 

4. Create the MKE cluster:

   ```shell
   mkectl apply -f mke4.yaml
   ```

   {{< callout type="info" >}}
   Upon successful completion of the MKE 4 installation, a username and password
   will be automatically generated and displayed once for you to use.

   To explicitly set a password value, run `mkectl apply -f mke4.yaml --admin-password <password>` .
   {{< /callout >}}   
  

5. Install and configure Load Balancer: 
 
    If you chose an external loadbalancer eq. ELB or Octavia please check instructions [here](https://docs.mirantis.com/mke-docs/docs/getting-started/system-requirements/#load-balancer-requirements).

    {{< callout type="info" >}}
    If you work with MKE <4.0.1 there is a bug while you working with ip instead of FQDN with you external load balancer.

    ```shell
    kubectl edit certificate -n mke mke-ingress-cert
    ```
    and add your load balancer IP or public address to the ipAddresses section

    {{< /callout >}}



    Please chose the appropriate package manager for your operating system, in this example we're using apt (Debian/Ubuntu)


    ```shell
    apt update && apt install haproxy
    ```

    open the haproxy config file (Ubuntu: /etc/haproxy/haproxy.conf) and edit/add to frontend and backend section. 

    ```shell
    global
        log /dev/log    local0 
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon



    defaults
        log     global
        mode    tcp
        option  httplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http

    frontend proxy
        bind *:443
        mode tcp
        option tcplog
        maxconn 10000
        use_backend mke

    backend mke
        server mke <server IP>:33001 verify none check
                                                     
    ```
    Now restart the HAProxy daemon:
    ```shell
    systemctl restart haproxy
    ````


6. Access the dashboard \
  You can access the dashboard with your browser \
  ```https://<IP>```

  {{< callout type="info" >}}
  Please be aware that those are self-signed certificates so you need to accept the warning your browser will show you.
  {{< /callout >}}   
