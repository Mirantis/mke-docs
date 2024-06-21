---
title: TCP and UDP services
weight: 3
---

The Kubernetes ingress resource only supports services over HTTP and HTTPS.
Using NGINX Ingress Controller, however, you can receive external TCP/UDP
traffic from non-HTTP protocols and route them to internal services using
TCP/UDP port mappings.

## Expose a TCP service

To expose TCP services, set the following parameters in the MKE 4 configuration
file.

| Field                           | Description                                        |
|---------------------------------|----------------------------------------------------|
| ingressController.tcpServices   | Indicates TCP service key-value pairs.             |
| ingressController.nodePorts.tcp | Sets node port mapping for external TCP listeners. |

In the example procedure, a `tcp-echo` service that is running in the default namespace on port 9000 is exposed using the port 9000, on `NodePort` 33011.

1. Deploy a sample TCP service listening on port 9000, to echo back any text it
   receives with the prefix `hello`:

   ```yaml
   cat <<EOF | kubectl apply -f -
   apiVersion: v1
   kind: Service
   metadata:
     name: tcp-echo
     labels:
       app: tcp-echo
       service: tcp-echo
   spec:
     selector:
       app: tcp-echo
     ports:
       - name: tcp
         port: 9000

   ---

   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: tcp-echo
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: tcp-echo
     template:
       metadata:
         labels:
           app: tcp-echo
       spec:
         containers:
           - name: tcp-echo
             image: docker.io/istio/tcp-echo-server:1.2
             imagePullPolicy: IfNotPresent
             args: [ "9000", "hello" ]
             ports:
               - containerPort: 9000
   EOF
   ```

2. Verify that the deployment was created correctly:

   ```shell
   kubectl get deploy tcp-echo
   ```

   Example output:

   ```shell
   NAME           READY   UP-TO-DATE   AVAILABLE   AGE
   tcp-echo       1/1     1            1           39s
   ```

3. Verify that the service is running:

   ```shell
   kubectl get service tcp-echo
   ```

   Example output:

   ```shell
   NAME           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
   tcp-echo       ClusterIP   10.96.172.90   <none>        9000/TCP   46s
   ```

4. Configure Ingress Controller to expose the TCP service:

   1. Verify that the `enabled` parameter for the `ingressController` option in
      the MKE configuration file is set to `true`.
   2. Modify the MKE configuration file to expose the newly created TCP service:

      ```yaml
      ingressController:
        enabled: true
        tcpServices:
          "9000": default/tcp-echo:9000
        nodePorts:
          tcp:
            9000: 33011
      ```

5. Apply the MKE configuration file:

   ```shell
   mkectl apply  -f mke.yaml
   ```

6. Test the TCP service by sending the text `hello world`:

   ```shell
   echo "world" | netcat <WORKER_NODE_IP> 33011
   hello world
   ```

   The service should respond with `hello world`.

7. Check the tcp-echo logs:

   1. Obtain the Pod name:

      ```shell
      kubectl get pods --selector=app=tcp-echo
      ```

      Example output:

      ```shell
      NAME                        READY   STATUS    RESTARTS   AGE
      tcp-echo-544849bd8f-6jscx   1/1     Running   0          45h
      ```

   2. Access the log:

      ```shell
      kubectl logs tcp-echo-544849bd8f-6jscx
      ```

      Example output:

      ```shell
      listening on [::]:9000, prefix: hello
      request: world
      response: hello world
      ```

8. Remove the Kubernetes resources, which are no longer needed:

   ```shell
   kubectl delete service tcp-echo
   kubectl delete deployment tcp-echo
   ```
## Expose a UDP service

To expose UDP services, set the following parameters in the MKE 4 configuration
file.

| Field                           | Description                                       |
|---------------------------------|---------------------------------------------------|
| ingressController.udpServices   | Indicates UDP service key-value pairs.                                                  |
| ingressController.nodePorts.udp | Sets node port mapping for external UDP listeners. |

In the example procedure, a `udp-listener` service running in the default namespace on port 5005 is exposed using the port 5005, on `NodePort` 33012.

1. Deploy a sample UDP service listening on port 5005:

   ```yaml
   cat <<EOF | kubectl apply -f -
   apiVersion: v1
   kind: ServiceAccount
   metadata:
     name: udp-listener

   ---

   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: udp-listener
     labels:
       app: udp-listener
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: udp-listener
     template:
       metadata:
         labels:
           app: udp-listener
       spec:
         containers:
           - name: udp-listener
             image: mendhak/udp-listener
             ports:
               - containerPort: 5005
                 protocol: UDP
                 name: udp

   ---

   apiVersion: v1
   kind: Service
   metadata:
     name: udp-listener
   spec:
     ports:
       - port: 5005
         targetPort: 5005
         protocol: UDP
         name: udp
     selector:
       app: udp-listener
   EOF
   ```

2. Verify that the deployment was created correctly:

   ```shell
   kubectl get deploy udp-listener
   ```

   Example output:

   ```shell
   NAME           READY   UP-TO-DATE   AVAILABLE   AGE
   udp-listener   1/1     1            1           31s
   ```

3. Verify that the service is running:

   ```shell
   kubectl get service udp-listener
   ```

   Example output:

   ```shell
   NAME           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
   udp-listener   ClusterIP   10.96.19.229   <none>        5005/UDP   37s
   ```

4. Configure Ingress Controller to expose the UDP service:

   1. Verify that the `enabled` parameter for the `ingressController` option in
      the MKE configuration file is set to `true`.

   2. Modify the MKE configuration file to expose the newly created UDP
      service:

      ```yaml
      ingressController:
        enabled: true
        udpServices:
          "5005": default/udp-listener:5005
        nodePorts:
          udp:
            5005: 33012
      ```

5. Apply the MKE configuration file:

   ```shell
   mkectl apply  -f mke.yaml
   ```

6. Test the UDP service by sending the UDP Datagram Message:

   ```shell
   echo "UDP Datagram Message" | netcat -v -u <WORKER_NODE_IP> 33012
   ```

7. Check the `udp-listener` logs:

   1. Obtain the Pod name:

      ```shell
      kubectl get pods --selector=app=udp-listener
      ```

      Example output:

      ```shell
      NAME                           READY   STATUS    RESTARTS   AGE
      udp-listener-f768d8db4-v69jr   1/1     Running   0          44h
      ```

   2. Access the log:

      ```shell
      kubectl logs udp-listener-f768d8db4-v69jr
      ```

      Example output:


      ```shell
      Listeningon UDP port 5005
      UDP Datagram Message
      ```

8. Remove the Kubernetes resources, which are no longer needed:

   ```shell
   kubectl delete service udp-listener
   kubectl delete deployment udp-listener
   ```