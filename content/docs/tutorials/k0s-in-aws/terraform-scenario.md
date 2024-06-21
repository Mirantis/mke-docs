---
weight: 1
---

# Scenario: Create a k0s cluster in AWS using Terraform and install MKE on that cluster

## Prerequisites

In addition to the MKE [dependencies](../../../getting-started/install-MKE-CLI),
you need to do the following:

- Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
  (required for creating VMs in AWS)
- Create an AWS account
- Set the environment variables for the AWS CLI:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_SESSION_TOKEN`

## Create virtual machines on AWS

To create virtual machines on AWS using the example Terraform scripts:

1. Copy the [example Terraform folder](./terraform) to your local machine.
2. Create a `terraform.tfvars` file with content similar to:

   ```
   cluster_name = "k0s-cluster"
   controller_count = 1
   worker_count = 1
   cluster_flavor = "m5.large"
   region = "us-east-1"
   ```

3. Run `terraform init`.
4. Run `terraform apply -auto-approve`.
5. Run `terraform output --raw k0s_cluster > VMs.yaml`.

{{< callout type="info" >}}

To get detailed information on the virtual machines using the AWS CLI, run:

```shell
aws ec2 describe-instances --region $(grep "region" terraform.tfvars | awk -F' *= *' '{print $2}' | tr -d '"')
```

Alternatively, you can get a visual overview of the virtual machines at the AWS EC2 page
by selecting the desired region from the dropdown menu in the top-right corner.

{{< /callout >}}

## Install MKE on k0s

1. Generate a sample `mke.yaml` file:

   ```shell
   mkectl init > mke.yaml
   ```

2. Edit the `hosts` section in `mke.yaml` using the values from the `VMs.yaml`
   file. Example configuration of the `hosts` section:

   ```yaml
   hosts:
     - role: controller+worker
       ssh:
         address: 54.91.231.190
         keyPath: <path_to_terraform_folder>/aws_private.pem
         port: 22
         user: ubuntu
     - role: worker
       ssh:
         address: 18.206.202.16
         keyPath: <path_to_terraform_folder>/aws_private.pem
         port: 22
         user: ubuntu
   ```

3. Create the MKE cluster:

   ```shell
   mkectl apply -f mke.yaml
   ```

## Clean up infrastructure

To clean up and tear down infrastructure that is no longer needed, ensuring that all resources
managed by Terraform are properly deleted, navigate to the Terraform folder and run:

``` bash
terraform destroy --auto-approve
```

After successfully destroying the resources, Terraform will update the state file
to reflect that the resources no longer exist.
