---
title: Ingress controller
weight: 3
---

Traffic that originates outside of your cluster, *ingress* traffic, is managed
through the use of an ingress controller. By default, MKE 4 offers NGINX
Ingress Controller, which manages ingress traffic using the [Kubernetes
Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
rules.

NGINX Ingress Controller is the only one ingress controller that MKE 4
currently supports.

## Configuration

You can configure NGINX Ingress Controller through the `ingressController`
section of the MKE 4 configuration file. The function is enabled by default
and must not be disabled for the cluster to function correctly.

Ingress controller parameters that you can configure are
detailed in the following table.

| Field                           | Description                                                                                                                                                                                                                                                                                                                                                                                     | Default                                                                            |
|---------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------|
| replicaCount                    | Sets the number of NGINX Ingress Controller deployment replicas.                                                                                                                                                                                                                                                                                                                                | 2                                                                                  |
| enableLoadBalancer              | Enables an external load balancer. <br><br/>Valid values: `true`, `false`.                                                                                                                                                                                                                                                                                                                      | `true` if `apiServer.externalAddress` is set in the config file; `false` otherwise |
| extraArgs                       | Additional command line arguments to pass to Ingress-Nginx Controller.                                                                                                                                                                                                                                                                                                                          | {} (empty)                                                                         |                                                                                                                                                                                                                    
| extraArgs.httpPort              | Sets the container port for servicing HTTP traffic.                                                                                                                                                                                                                                                                                                                                             | `80`                                                                               |
| extraArgs.httpsPort             | Sets the container port for servicing HTTPS traffic.                                                                                                                                                                                                                                                                                                                                            | `443`                                                                              |
| extraArgs.enableSslPassthrough  | Enables SSL passthrough.                                                                                                                                                                                                                                                                                                                                                                        | false                                                                              |
| extraArgs.defaultSslCertificate | The only valid value is `mke/auth-https.tls`. Must NOT be changed.                                                                                                                                                                                                                                                                                                                              | `mke/auth-https.tls`                                                               |
| preserveClientIP                | Enables preserving inbound traffic source IP. <br><br/>Valid values: `true`, `false`.                                                                                                                                                                                                                                                                                                           | `false`                                                                            |
| externalIPs                     | Sets the list of external IPs for Ingress service. IP addresses of managers nodes are always added automatically.                                                                                                                                                                                                                                                                               | []                                                                                 |
| affinity                        | Sets node affinity. [Example](#affinity) <br/> Affinity is always configured to schedule ingress controller pods on manager nodes. Additional rules may be added, but it's not recommended. <br/> <br/> For more information, refer to the Kubernetes documentation [Affinity and anti-affinity](https://kubernetes.io/docs/concepts/configuration/assign-pod-node#affinity-and-anti-affinity). | {} (empty)                                                                         |
| tolerations                     | Sets node toleration. [Example](#tolerations) <br/> Tolerations are always configured to allow scheduling on manager nodes. Additional rules may be added, but it's not recommended. <br/> <br/> Refer to the Kubernetes documentation [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/) for more detail.                                           | [] (empty)                                                                         |          
| configMap                       | Adds custom configuration options to Nginx.  <br/><br/>  For a complete list of available options, refer to the [NGINX Ingress Controller ConfigMap](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#configuration-options).                                                                                                                               | {} (empty)                                                                         |
| tcpServices                     | Sets TCP service key-value pairs; enables TCP services. [Example](../ingress/tcp-udp-services) <br/> <br/>  Refer to the NGINX Ingress documentation [Exposing TCP and UDP services](https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/exposing-tcp-udp-services.md) for more information. for more information.                                                                 | {} (empty)                                                                         |
| udpServices                     | Sets UDP service key-value pairs; enables UDP services. [Example](../ingress/tcp-udp-services) <br/> <br/>  Refer to the NGINX Ingress documentation [Exposing TCP and UDP services](https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/exposing-tcp-udp-services.md) for more information.                                                                                       | {} (empty)                                                                         |
| nodePorts                       | Sets the node ports for the external HTTP/HTTPS/TCP/UDP listener. You should not change the HTTPS port, but if you do so, make sure to change the target port of the MKE Dashboard in your load balancer configuration. Refer to [System requirements](../../getting-started/system-requirements) for more information.                                                       | HTTP: 33000, HTTPS: 33001                                                          |
| ports                           | Sets the port for the internalHTTP/HTTPS listener.                                                                                                                                                                                                                                                                                                                                              | HTTP: 80, HTTPS: 443                                                               |
| disableHttp                     | Disables the HTTP listener.                                                                                                                                                                                                                                                                                                                                                                     | false                                                                              |

### Affinity

You can specify node affinities using the
`ingressController.affinity.nodeAffinity` field in the MKE configuration file.

The following example uses `requiredDuringSchedulingIgnoredDuringExecution` to
schedule the ingress controller pods.

```yaml
ingressController:
  enabled: true
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: kubernetes.io/hostname
                operator: In
                values:
                  - ip-172-31-42-30
```

### Tolerations

You can set Node tolerations for server scheduling to nodes with taints using
the `ingressController.tolerations` field in the MKE configuration file.

The following example uses a toleration with `NoExecute` effect.

```yaml
ingressController:
  enabled: true
  tolerations:
  - key: "key1"
    operator: "Equal"
    value: "value1"
    effect: "NoExecute"
```

## Example ingress controller configuration

```yaml
ingressController:
  enabled: true
  enableLoadBalancer: false
  numReplicas: 1
  preserveClientIP: true
  tolerations:
    - key: "key1"
      operator: "Equal"
      value: "value1"
      effect: "NoExecute"
  extraArgs:
    httpPort: 80
    httpsPort: 443
    enableSslPassthrough: false
  configMap:
    access-log-path: "/var/log/nginx/access.log"
    generate-request-id: "true"
    use-forwarded-headers: "true"
    error-log-path: "/var/log/nginx/error.log"
  tcpServices:
    9000: "default/tcp-echo:9000"
  udpServices:
    5005: "default/udp-listener:5005"
  nodePorts:
    http: 33000
    https: 33001
    tcp:
      9000: 33011
    udp:
      5005: 33012
  ports:
    http: 8080
    https: 4443
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: kubernetes.io/hostname
                operator: In
                values:
                  - ip-172-31-42-30
```


## MKE version comparison: Ingress configuration parameters

| MKE-3                                                                                                                                                                        | MKE-4                                                                                                                                                                                                                                                                                                                                                                                                                |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [cluster_config.ingress_controller.enabled]                                                                                                                                  | ingressController.enabled                                                                                                                                                                                                                                                                                                                                                                                            |
 | [cluster_config.ingress_controller.ingress_num_replicas]                                                                                                                     | ingressController.numReplicas                                                                                                                                                                                                                                                                                                                                                                                        |
 | [cluster_config.ingress_controller.ingress_enable_lb]                                                                                                                        | ingressController.enableLoadBalancer                                                                                                                                                                                                                                                                                                                                                                                 |
 | [cluster_config.ingress_controller.ingress_preserve_client_ip]                                                                                                               | ingressController.preserveClientIP                                                                                                                                                                                                                                                                                                                                                                                   |
| [[cluster_config.ingress_controller.ingress_node_toleration]] <br/> key = "com.docker.ucp.manager" <br/> value = "" <br/> operator = "Exists" <br/>effect = "NoSchedule"     | ingressController.tolerations </br> - key: "key1" </br> operator: "Equal" </br> value: "value1" </br> effect: "NoExecute"                                                                                                                                                                                                                                                                                            |
 | [cluster_config.ingress_controller.ingress_config_map]                                                                                                                       | ingressController.configMap                                                                                                                                                                                                                                                                                                                                                                                          |
 | [cluster_config.ingress_controller.ingress_tcp_services] <br/> 9000 = "default/tcp-echo:9000"                                                                                | ingressController.tcpServices:<br/>9000: "default/tcp-echo:9000"                                                                                                                                                                                                                                                                                                                                                     |
 | [cluster_config.ingress_controller.ingress_udp_services] <br/> 5005 = "default/udp-listener:5005"                                                                            | ingressController.udpServices:<br/> 5005: "default/udp-listener:5005"                                                                                                                                                                                                                                                                                                                                                |
 | [cluster_config.ingress_controller.ingress_extra_args] <br/> http_port = 8080 <br/> https_port = 4443 <br/> enable_ssl_passthrough = true <br/> default_ssl_certificate = "" | ingressController.extraArgs: <br/> httpPort: 0 <br/> httpsPort: 0 <br/> enableSslPassthrough: true <br/> defaultSslCertificate: ""                                                                                                                                                                                                                                                                                   |
 | [cluster_config.ingress_controller.ingress_node_affinity]                                                                                                                    | ingressController.affinity                                                                                                                                                                                                                                                                                                                                                                                           |                                                                                                        |                                                                                                                                    |
 | [[cluster_config.ingress_controller.ingress_exposed_ports]] <br/> name = "http2" <br/> port = 80 <br/> target_port = 8080 <br/> node_port = 33001 <br/> protocol = ""        | Deprecated in MKE 4.<br/>  <br/> The http and https ports are enabled by default on 80 and 443 respectively.  If the user wants to change it, they can use ingressController.ports.<br><br/> NodePorts for http and https can be configured via ingressController.nodePorts. The default values are 33000 and 33001 respectively. <br><br> For information on how to configure TCP/UDP ports, refer to the [TCP and UDP services documentation](../ingress/tcp-udp-services). |