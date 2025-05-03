---
title: Create a Kubernetes cluster in AWS using Terraform and install MKE 4k
weight: 1
---

## Prerequisites

In addition to the MKE 4k
[dependencies](../../../getting-started/install-mke-cli), you need to do the
following:

- Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
  (required for creating VMs in AWS)
- Create an AWS account
- Set the environment variables for the AWS CLI:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_SESSION_TOKEN`

## Create virtual machines on AWS

To create virtual machines on AWS using the example Terraform scripts:

1. Copy the [example Terraform
   folder](https://github.com/Mirantis/mke-docs/tree/main/content/docs/tutorials/k0s-in-aws/terraform)
   to your local machine.
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

## Install MKE 4k on k0s

1. Generate a sample `mke4.yaml` file:

   ```shell
   mkectl init > mke4.yaml
   ```

2. Edit the `hosts` section in `mke4.yaml` using the values from the `VMs.yaml`
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

3. Edit the `apiServer.externalAddress` in the configuration file

   ```sh
   terraform output -raw lb_dns_name | { read lb; yq -i ".apiServer.externalAddress = \"$lb\"" mke4.yaml; }
   ```

   If you do not have the `yq` tool installed, edit the `mke4.yaml` file manually
   setting `apiServer.externalAddress` to the output of the `terraform output -raw lb_dns_name` command.

4. Create the MKE 4k cluster:

   ```shell
   mkectl apply -f mke4.yaml
   ```

   {{< callout type="info" >}} Upon successful completion of the MKE 4k
   installation, a username and password will be automatically generated and
   displayed once for you to use.

   To explicitly set a password value, run `mkectl apply -f mke4.yaml --admin-password <password>` .
   {{< /callout >}}

## Clean up infrastructure

To clean up and tear down infrastructure that is no longer needed, ensuring that all resources
managed by Terraform are properly deleted, navigate to the Terraform folder and run:

```bash
terraform destroy --auto-approve
```

After successfully destroying the resources, Terraform will update the state file
to reflect that the resources no longer exist.
