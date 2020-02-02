# HashiCorp Vault Cluster - Step 1: AMIs

In this example we'll create the base AMIs needed to setup a HashiCorp Vault and Consul cluster.

The repository we'll use is a fork of [https://github.com/hashicorp/terraform-aws-vault](the GitHub repository) provided by HashiCorp.

## Prerequisites

- See the prerequisites-section [here](../VPC/README.md).

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

Instead of creating the resources below, you can also use the environment already in the infraxys-by-examples module.

- Create environment "vault-amis" under your custom infraxys-by-example module.
- Add a container with name "vault-amis" and description "AMIs for Vault and Consul".
