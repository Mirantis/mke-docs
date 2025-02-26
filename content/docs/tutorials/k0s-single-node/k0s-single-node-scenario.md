---
title: Create a Kubernetes cluster in single node and install MKE
weight: 2
---

{{< callout type="warning" >}}
Do not deploy the cluster that results from this tutorial in a production
environment. It is intended for testing purposes only.
{{< /callout >}}

## Prerequisites
In addition to ensuring that the MKE [dependencies](../../../getting-started/install-mke-cli)
and MKE [system requirements](../../../getting-started/system-requirements)
are met, perform the following actions:

- Provide a virtual machine, either locally or on a provider that has an accessible IP address
- Open the following ports:
  - `80` (HTTP)
  - `443` (HTTPs)
  - `6443` (Kubernetes API)
  - `22` (SSH)
- Configure SSH access by way of an SSH-key


## Install MKE on k0s

1. Generate a sample configuration file named `mke4.yaml`:

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
3. Edit the `apiServer` section in the configuration file to add the
   `externalAddress` and `sans` parameters, which are necessary to generate the 
   correct certificate: 

   * `externalAddress`: The public/floating IP of the node
   * `sans`: The IP addresses with which you want to connect 

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
    

4. Create the MKE cluster:

   ```shell
   mkectl apply -f mke4.yaml
   ```

   {{< callout type="info" >}}
   A username and password are automatically generated and displayed upon successful completion of the MKE 4 cluster. 
   To explicitly set a password that differs from the one automatically generated, run: 
   ```shell
   mkectl apply -f mke4.yaml --admin-password <PW>
   ```
   {{< /callout >}}
   
5. Install and configure a load balancer/proxy.

    {{< callout type="info" >}}

    - To configure an external load balancer, such as ELB or Octavia, refer to the [Load balancer requirements](../../../getting-started/system-requirements/#load-balancer-requirements).

    - If you are running an MKE installation prior to 4.0.1, unless you are using a regular FQDN you must add your load balancer IP/proxy or public address to the `ipAddresses` section of the certificate object:

      ```shell
      kubectl edit certificate -n mke mke-ingress-cert
      ```

    {{< /callout >}}

    Example, using APT for Debian/Ubuntu:

    a. Update and install HAProxy:

      ```shell
      apt update && apt install haproxy
      ```

    b. Locate and open the `haproxy.conf` file (Ubuntu: `/etc/haproxy/haproxy.conf`).
    
    c. Append the frontend and backend sections of the `haproxy.conf` file: 

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

    d. Restart the HAProxy daemon:

      ```shell
      systemctl restart haproxy
      ````

6. Access the MKE Dashboard at `https://<IP>`. Be aware that as the
   certificates are self-signed, you must accept the displayed warning.