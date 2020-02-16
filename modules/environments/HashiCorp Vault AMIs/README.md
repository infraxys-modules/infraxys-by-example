# HashiCorp Vault Cluster - Step 1: AMIs

## This example is still work in progress. First, the installation of Infraxys Server will be done.


In this example we'll create the base AMIs needed to setup a HashiCorp Vault and Consul cluster.

The repository we'll use is a fork of [https://github.com/hashicorp/terraform-aws-vault](the GitHub repository) provided by HashiCorp.

## Prerequisites

- See the prerequisites-section [here](../VPC/README.md).

## Preparation
 
### Required modules

Make sure the following modules are in your module-list:
 - [AWS Packer module](https://github.com/infraxys-aws/aws-packer).
 
## Create Infraxys resources

We'll be creating a separate environment for the AMI-creation step so that we can show how information can be shared between environments.
These environments can exist in totally different projects and managed by different teams.
The security-team, for example, could manage the "golden" AMIs across the company and all other teams can then use these. 

### Share the VPC container with all sibling projects

- Open your infraxys-by-example project.
- Click the "Included containers"-tab.
- Select the vpc-example environment in the project tree.
- Drag container "vpc-example" onto the top-left table under the "included containers"-tab

### Create AMI environment

Instead of creating the following resources, you can also use the environment already in the infraxys-by-examples module.

- Create environment "vault-amis" under your custom infraxys-by-example module.
- Add a container with name "vault-amis" and description "AMIs for Vault and Consul".
- Drag packet "Packer AWS build environment" from the aws-packer module onto the root instance in the instances-tab.
- Enter "vpc" in "VPC Velocity name". This is the Velocity name of the VPC-instance of the vpc-example.
- 
-
- In "Bastion name" enter `$bastionHost.getAttribute("bastion_name")`. "bastionHost" is the Velocity name of the bastion instance of the vpc-example.
- "bsa"
