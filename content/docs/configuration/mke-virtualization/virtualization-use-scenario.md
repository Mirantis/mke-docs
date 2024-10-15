---
title: MKE virtualization deployment scenario
weight: 5
---

The example scenario illustrated herein pertains to the deployment of a CirrOS
virtual machine, which is comprised by the following primary steps:

1. Launch a simple virtual machine
2. Attach a disk to a virtual machine
3. Attach a network interface to a virtual machine

## Launch a basic virtual machine

1. Create a `cirros-vm.yaml` file.

   ```bash
   kubectl apply -f
   https://binary-mirantis-com.s3.amazonaws.com/kubevirt/manifests/examples/cirros-vm.yaml
   ```

   Alternatively, you can manually create the `cirros-vm.yaml` file, using the
   following content:

   ```yaml
   ---
   apiVersion: kubevirt.io/v1
   kind: VirtualMachine
   metadata:
     labels:
       kubevirt.io/vm: vm-cirros
     name: vm-cirros
   spec:
     running: false
     template:
       metadata:
         labels:
           kubevirt.io/vm: vm-cirros
       spec:
         domain:
           devices:
             disks:
             - disk:
                 bus: virtio
               name: containerdisk
             - disk:
                 bus: virtio
               name: cloudinitdisk
           resources:
             requests:
               memory: 128Mi
         terminationGracePeriodSeconds: 0
         volumes:
         - containerDisk:
             image: mirantis.azurecr.io/kubevirt/cirros-container-disk-demo:1.3.1-20240911005512
           name: containerdisk
         - cloudInitNoCloud:
             userData: |
               #!/bin/sh

               echo 'printed from cloud-init userdata'
           name: cloudinitdisk
   ```

2. Apply the `cirros-vm.yaml` file.

   ```bash
   kubectl apply -f cirros-vm.yaml
   ```

3. Verify the creation of the virtual machine:

   ```bash
   kubectl get vm
   ```

   Example output:

   ```bash
   NAME        AGE    STATUS    READY
   vm-cirros   1m8s   Stopped   False
   ```

4. Start the CirrOS VM:

   ```bash
   virtctl start vm-cirros
   ```

5. Access the CirrOS console:

   ```bash
   virtctl console vm-cirros
   ```

## Attach a disk to a virtual machine

{{< callout type="note" >}}
  The following example scenario uses the `HostPathProvisioner` component,
  which is deployed by default.
{{< /callout >}}

1. Manually create the `example-pvc.yaml` file, using the
   following content:

   ```yaml
   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
     name: pvc-claim-1
   spec:
     storageClassName: hpp-local
     accessModes:
       - ReadWriteOnce
     resources:
       requests:
         storage: 3Gi
   ```

2. Create the `PersistentVolumeClaim` resource that you defined in the
   `example-pvc.yaml` file::

   ```bash
   kubectl apply -f example-pvc.yaml
   ```

3. Verify the creation of the volume:

   ```bash
   kubectl get pvc
   ```

   Example output:

   ```bash
   NAME          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS    AGE
   pvc-claim-1   Bound    pvc-b7d68902-f340-4b7e-8a36-495d170b7193   10Gi       RWO            hpp-local       10s
   ```

4. Attach the disk to your virtual machine:

   ```bash
   kubectl patch vm vm-cirros --type='json' -p
   '[{"op":"add","path":"/spec/template/spec/volumes/2","value":{"persistentVolumeClaim":
   {"claimName": "pvc-claim-1"},"name":
   "example-pvc"}},{"op":"add","path":"/spec/template/spec/domain/devices/disks/2","value":{"disk":
   {"bus": "virtio"},"name": "example-pvc"}}]'
   ```

5. Restart the virtual machine and access the console:

   ```bash
   virtctl restart vm-cirros

   virtctl console vm-cirros
   ```

6. Format and mount the disk:

   ```bash
   sudo mkfs.ext3 /dev/vdc

   sudo mkdir /example-disk

   sudo mount /dev/vdc /example-disk
   ```

7. Create a `helloworld.txt` file to verify that the disk works:

   ```bash
   sudo touch /example-disk/helloworld.txt

   ls /example-disk/
   ```

## Attach a network interface to a virtual machine

{{< callout type="note" >}}
  The following example scenario requires the presence of CNAO.
{{< /callout >}}

1. Manually create the `bridge-test.yaml` file, using the
   following content:

   ```yaml
   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: bridge-test
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "bridge-test",
         "type": "bridge",
         "bridge": "br1",
         "ipam": {
           "type": "host-local",
           "subnet": "10.250.250.0/24"
         }
       }'
   ```

2. Apply the `bridge-test.yaml` file:

   ```bash
   kubectl apply -f bridge-test.yaml
   ```

3. Attach the network interface to your virtual machine:

   ```bash
   kubectl patch vm vm-cirros --type='json' -p
   '[{"op":"add","path":"/spec/template/spec/domain/devices/interfaces","value":[{"name":"default","masquerade":{}},{"name":"bridge-net","bridge":{}}]},{"op":"add","path":"/spec/template/spec/networks","value":[{"name":default,"pod":{}},{"name":"bridge-net","multus":{"networkName":"bridge-test"}}]}]'
   ```

4. Restart the VM and access the console:

   ```bash
   virtctl restart vm-cirros

   virtctl console vm-cirros
   ```

5. Verify the VM interfaces:

   ```bash
   ip a
   ```

   Example output:

   ```bash
   1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
       link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
       inet 127.0.0.1/8 scope host lo
          valid_lft forever preferred_lft forever
       inet6 ::1/128 scope host
          valid_lft forever preferred_lft forever
   2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc pfifo_fast qlen 1000
       link/ether 0a:c5:3b:63:71:51 brd ff:ff:ff:ff:ff:ff
       inet 10.0.2.2/24 brd 10.0.2.255 scope global eth0
          valid_lft forever preferred_lft forever
       inet6 fe80::8c5:3bff:fe63:7151/64 scope link
          valid_lft forever preferred_lft forever
   3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop qlen 1000
       link/ether 6a:bb:20:5b:6a:5e brd ff:ff:ff:ff:ff:ff
   ```
