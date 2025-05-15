---
title: Cloud providers
weight: 9
---

With MKE 4, you can deploy a cloud provider to integrate your MKE 4k cluster with cloud provider service APIs.

{{< callout type="info" >}}
AWS is currently the only managed cloud service provider add-on that MKE 4k supports. You can use a different cloud service provider; however, you must change the `provider` parameter under `cloudProvider` in the `mke4.yaml` configuration file to `external` prior to installing that provider:

```yaml
  cloudProvider:
    enabled: true
    provider: external
```
{{< /callout >}}

## Prerequisites

Refer to the documentation for your chosen cloud service provider to ascertain any proprietary requirements.

To use the MKE 4k managed AWS Cloud Provider, you must first ensure that your nodes have certain IAM policies. For detailed information, refer to the official AWS Cloud Provider documentation [IAM Policies](https://cloud-provider-aws.sigs.k8s.io/prerequisites/#iam-policies).

## Configuration

To enable cloud provider support, which is disabled by default, change the `enabled` parameter under `cloudProvider` in the `mke4.yaml` configuration file to `true`:

```yaml
  cloudProvider:
    enabled: true
    provider: aws
```

The `cloudProvider` configuration parameters are detailed in the following table:

| Field      | Description                                                                                                             | Default   |
|------------|-------------------------------------------------------------------------------------------------------------------------|-----------|
| `enabled`  | Enables cloud provider flags on MKE 4k components.                                                                         | `false`   |
| `provider` | Either `aws` or `external`. If "external" is specified the user is responsible for installing their own cloud provider. | ""    ``  |


## Create an NLB with AWS Cloud Provider

The example below illustrates how you can use cloud provider AWS to create a
Network Load Balancer (NLB) in your MKE 4k cluster. 

Once you have enabled the cloud provider through the `mke4.yaml` configuration file and have applied it, you can create an NLB as follows:


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

<img src="/mke-docs/images/aws-lb.png" id="myBtn"></img>

<div id="myModal" class="modal">
  <div class="modal-content">
    <span class="close">&times;</span>
    <img src="/mke-docs/images/aws-lb.png">
  </div>
</div>

<script>
var modal = document.getElementById("myModal");
var btn = document.getElementById("myBtn");
var span = document.getElementsByClassName("close")[0];

// When the user clicks the button, open the modal
btn.onclick = function() {
  modal.style.display = "block";
}

// When the user clicks on <span> (x), close the modal
span.onclick = function() {
  modal.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modal) {
    modal.style.display = "none";
  }
}
</script>

<style>
.modal {
  display: none; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  padding-top: 100px; /* Location of the box */
  left: 0;
  top: 0;
  width: 90%; /* Full width */
  height: 90%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0,0,0); /* Fallback color */
  background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}

/* Modal Content */
.modal-content {
  background-color: #fefefe;
  margin: auto;
  padding: 20px;
  border: 1px solid #888;
  width: 80%;
}

/* The Close Button */
.close {
  color: #aaaaaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: #000;
  text-decoration: none;
  cursor: pointer;
}
</style>

Once the load balancer finishes provisioning, you should be able to access
nginx through the external IP.

<img src="/mke-docs/images/aws-lb-provisioned.png" id="myBtn"></img>

<div id="myModal" class="modal">
  <div class="modal-content">
    <span class="close">&times;</span>
    <img src="/mke-docs/images/aws-lb-provisioned.png">
  </div>
</div>

<script>
var modal = document.getElementById("myModal");
var btn = document.getElementById("myBtn");
var span = document.getElementsByClassName("close")[0];

// When the user clicks the button, open the modal
btn.onclick = function() {
  modal.style.display = "block";
}

// When the user clicks on <span> (x), close the modal
span.onclick = function() {
  modal.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modal) {
    modal.style.display = "none";
  }
}
</script>

<style>
.modal {
  display: none; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  padding-top: 100px; /* Location of the box */
  left: 0;
  top: 0;
  width: 90%; /* Full width */
  height: 90%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0,0,0); /* Fallback color */
  background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}

/* Modal Content */
.modal-content {
  background-color: #fefefe;
  margin: auto;
  padding: 20px;
  border: 1px solid #888;
  width: 80%;
}

/* The Close Button */
.close {
  color: #aaaaaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: #000;
  text-decoration: none;
  cursor: pointer;
}
</style>
