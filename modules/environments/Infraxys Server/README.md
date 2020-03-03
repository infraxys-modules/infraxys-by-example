# Infraxys Server Step 1 - Create AMIs 

In this example, an AWS AMI that contains a fully configured Infraxys Server will be created.
The VPC-example in this repository, Packer and Terraform will be used. 


## Prerequisites

- All pre-requisites of the VPC example apply here. 
 
## Preparation
 
### Required modules

Make sure the following modules are in your module-list:
 - [AWS Commons module](https://github.com/infraxys-aws/aws-commons). Follow the instructions in this module to create the necessary variables.
 - [AWS VPC module](https://github.com/infraxys-aws/aws-vpc)
 - [Terraform module](https://github.com/infraxys-modules/terraform)

See <a href="https://infraxys.io/topics/using-modules/#configure-infraxys" target="_blank">Configure Infraxys</a> on how to add the module. Webhooks are not needed in this case.
