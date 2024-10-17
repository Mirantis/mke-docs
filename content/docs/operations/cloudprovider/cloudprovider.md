---
title: Cloud providers
weight: 6
---

With MKE 4, you can deploy a cloud provider to integrate your MKE cluster with cloud provider service APIs.

{{< callout type="note" >}}
AWS is currently the only managed cloud service provider add-on that MKE 4 supports. You can use a different cloud service provider; however, you must change the `provider` parameter under `cloudProvider` in the MKE configuration file to `external` prior to installing that provider:

```yaml
  cloudProvider:
    enabled: true
    provider: external
```
{{< /callout >}}

## Prerequisites

Refer to the documentation for your chosen cloud service provider to ascertain any proprietary requirements.

To use the MKE managed AWS Cloud Provider, you must first ensure that your nodes have certain IAM policies. For detailed information, refer to the official AWS Cloud Provider documentation [IAM Policies](https://cloud-provider-aws.sigs.k8s.io/prerequisites/#iam-policies).

## Configuration

To enable cloud provider support, which is disabled by default, change the `enabled` parameter under `cloudProvider` in the MKE configuration file to `true`:

```yaml
  cloudProvider:
    enabled: true
    provider: aws
```

The `cloudProvider` configuration parameters are detailed in the following table:

| Field      | Description                                                                                                             | Default   |
|------------|-------------------------------------------------------------------------------------------------------------------------|-----------|
| `enabled`  | Enables cloud provider flags on MKE components.                                                                         | `false`   |
| `provider` | Either `aws` or `external`. If "external" is specified the user is responsible for installing their own cloud provider. | ""    ``  |


## Create an NLB with AWS Cloud Provider

The example below illustrates how you can use cloud provider AWS to create a Network Load Balancer (NLB) in your MKE cluster. 

Once you have enabled the cloud provider through the MKE configuration file and have applied it, you can create an NLB as follows:


1. Create a sample nginx deployment:

   ```shell
   cat <<EOF | kubectl --kubeconfig ~/.mke/mke.kubeconf apply -f -
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx-deployment
   spec:
     replicas: 3  
     selector:
       matchLabels:
         app: nginx
     template:
       metadata:
         labels:
           app: nginx
       spec:
         containers:
         - name: nginx-container
           image: nginx:latest
           ports:
           - containerPort: 80
   EOF
   ```

2. Create a service of type `LoadBalancer`:

   ```shell
   cat <<EOF | kubectl --kubeconfig ~/.mke/mke.kubeconf apply -f -
   apiVersion: v1
   kind: Service
   metadata:
     name: nginx-service
     annotations:
       service.beta.kubernetes.io/aws-load-balancer-type: nlb
   spec:
     selector:
       app: nginx
     ports:
       - protocol: TCP
         port: 80
         targetPort: 80
     type: LoadBalancer
   EOF
   ```

3. Check the status of the service:

   ```shell
   kubectl --kubeconfig ~/.mke/mke.kubeconf get service
   NAME            TYPE           CLUSTER-IP     EXTERNAL-IP                                                                        PORT(S)        AGE
   kubernetes      ClusterIP      10.96.0.1      <none>                                                                             443/TCP        14m
   nginx-service   LoadBalancer   10.96.177.89   afdf81e0681274c52acbb7b45add87a1-637d0d850105ea92.elb.ca-central-1.amazonaws.com   80:32927/TCP   63s
   ```

The load balancer should now be visible in the AWS console.

![aws-lb.png](aws-lb.png)

Once the load balancer finishes provisioning, you should be able to access nginx through the external IP.

![aws-lb-provisioned.png](aws-lb-provisioned.png)
