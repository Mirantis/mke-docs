---
title: Multus
weight: 11
---

Multus is a container network interface (CNI) plugin that enables the
attachment of multiple network interfaces to a single Pod.

By default, Pods in Kubernetes are connected to a single network
interface, which is the default network. With Multus CNI, though, Pods can have
multiple network interfaces for multi-homed connectivity. For more information,
refer to the [Multus CNI GitHub repository](https://github.com/k8snetworkplumbingwg/multus-cni).

## Enable Multus

Multus is disabled in MKE 4 by default. To enable the function, you must obtain
the MKE 4 configuration file, locate the `network.multus.enabled` section, set
the `enabled` parameter to `true`, and apply the new configuration.

1. Obtain the default MKE 4 configuration file:

   ```
   mkectl init
   ```

2. Navigate to the `network` section of the configuration file, and set the
   `enabled` parameter for multus to `true`.

   ```
   network:
     multus:
       enabled: true
   ```

3. Apply the configuration:

   ```
   mkectl apply -f mke4.yaml
   ```

4. Verify the successful deployment of Multus in the cluster:

   ```
   kubectl get daemonset,pods -n kube-system -l app=multus
   ```

   Example output:

   ```
   NAME                            DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
   daemonset.apps/kube-multus-ds   3         3         3       3            3           <none>          50s

   NAME                       READY   STATUS    RESTARTS   AGE
   pod/kube-multus-ds-8psck   1/1     Running   0          36s
   pod/kube-multus-ds-dltjh   1/1     Running   0          36s
   pod/kube-multus-ds-m2bsz   1/1     Running   0          36s
   ```

{{< callout type="tip" >}}
In MKE 4, you can disable Multus at any time, as opposed to MKE 3 where once
Multus is installed it cannot be disabled.
{{< /callout >}}

## Add a network interface

1. SSH in to each cluster node to install the CNI and to determine the primary
   network:

   **To download and extract the CNI plugin:**

      ```
      CNI_PLUGIN_VERSION=v1.3.0
      CNI_ARCH=amd64
      curl -sL https://github.com/containernetworking/plugins/releases/download/${CNI_PLUGIN_VERSION}/cni-plugins linux-${CNI_ARCH}-${CNI_PLUGIN_VERSION}.tgz | sudo tar xvz -C /opt/cni/bin/
      ```

   **To determine the primary network interface for the node:**

   You will use the primary network interface information to create the `NetworkAttachmentDefinitions` file.

      {{< callout type="info" >}}
      The name of the primary interface can vary with the underlying network adapter.
      {{< /callout >}}

      ```
      route
      ```

      {{< callout type="info" >}}
      eth0 is the primary network interface for most Linux distributions.
      {{< /callout >}}

      Example output:

      ```
      Kernel IP routing table
      Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
      default         ip-172-31-0-1.u 0.0.0.0         UG    100    0        0 ens5
      172.31.0.0      0.0.0.0         255.255.0.0     U     100    0        0 ens5
      ip-172-31-0-1.u 0.0.0.0         255.255.255.255 UH    100    0        0 ens5
      192.168.17.0    0.0.0.0         255.255.255.192 U     0      0        0 *
      ```

2. Create the `NetworkAttachmentDefinitions` file, to specify other networks:

   ```
   cat <<EOF | kubectl create -f -
   apiVersion: k8s.cni.cncf.io/v1
   kind: NetworkAttachmentDefinition
   metadata:
     name: ens5-network
   spec:
     config: |
       {
         "cniVersion": "0.3.1",
         "type": "macvlan",
         "master": "ens5",
         "mode": "bridge",
         "mtu": 9001,
         "ipam": {
           "type": "host-local",
           "subnet": "172.31.0.0/16",
           "rangeStart": "172.31.2.150",
           "rangeEnd": "172.31.2.200",
           "routes": [
             { "dst": "0.0.0.0/0" }
           ],
           "gateway": "172.31.2.1"
         }
       }
   EOF
   ```

3. Verify the creation of the the network attachment definition:

   ```
   kubectl get network-attachment-definition
   ```

   Example output:

   ```
   NAME           AGE
   ens5-network   44s
   ```

4. Create a multi-homed Pod:

   ```
   cat <<EOF | kubectl create -f -
   apiVersion: v1
   kind: Pod
   metadata:
     name: pod-additional-network
     annotations:
       k8s.v1.cni.cncf.io/networks: ens5-network
   spec:
     containers:
       - command:
           - sleep
           - "3600"
         image: busybox
         name: pods-simple-container
   EOF
   ```

5. Verify the network interfaces of the Pod:

   ```
   kubectl exec -it pod-additional-network -- ip a
   ```

   Example output:

   ```
   LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
       link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
       inet 127.0.0.1/8 scope host lo
          valid_lft forever preferred_lft forever
       inet6 ::1/128 scope host
          valid_lft forever preferred_lft forever
   2: eth0@if15: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 8951 qdisc noqueue qlen 1000
       link/ether 26:36:4c:44:9c:80 brd ff:ff:ff:ff:ff:ff
       inet 192.168.23.138/32 scope global eth0
          valid_lft forever preferred_lft forever
       inet6 fe80::2436:4cff:fe44:9c80/64 scope link
          valid_lft forever preferred_lft forever
   3: net1@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc noqueue
       link/ether 0e:a3:f7:e8:50:85 brd ff:ff:ff:ff:ff:ff
       inet 172.31.2.150/16 brd 172.31.255.255 scope global net1
          valid_lft forever preferred_lft forever
       inet6 fe80::ca3:f7ff:fee8:5085/64 scope link
          valid_lft forever preferred_lft forever
   ```

## Uninstall Multus

1. Obtain the MKE 4 configuration file.

2. Set the enabled field to false to disable Multus.

   ```
   network:
     multus:
       enabled: false
   ```

3. Apply the configuration:

   ```
   mkectl apply -f mke4.yaml
   ```