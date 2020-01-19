# AWS VPC environment

We'll create a fully configured AWS VPC using Terraform. 

## Prerequisites

- See the prerequisites-section [here](../../../prerequisites.md).
- An AWS account (this might incur a cost). See [Create an AWS account](https://portal.aws.amazon.com/billing/signup?redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start).
- AWS access key and secret. See [Managing Access Keys (Console)](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey).
- An S3-bucket to store the Terraform state files. This bucket needs to be writeable for the provided credentials. See [Terraform S3](https://www.terraform.io/docs/backends/types/s3.html).
 
## Preparation
 
### Required modules

Make sure the following modules are in your module-list:
 - [AWS Core module](https://github.com/infraxys-modules/aws-core). Follow the instructions in this module to create the necessary variables.
 - [AWS VPC module](https://github.com/infraxys-modules/aws-vpc)
 - [Terraform module](https://github.com/infraxys-modules/terraform)
 
### Using AWS credentials

Credentials can be kept in an external store, like HashiCorp Vault, or we can use Infraxys variables (which are also stored in Vault).
In this example we'll use variables and the AWS Core module to automatically retrieve temporary credentials from AWS.
  
See <a href="https://infraxys.io/topics/using-modules/#configure-infraxys" target="_blank">Configure Infraxys</a> on how to add the module. Webhooks are not needed in this case. 

## Create EC2 Key pair for the bastion host
We'll create a key pair and store it as a variable in Infraxys

- Login to the AWS-console and open the EC2-console of the account where the VPC will be created
- Click the "Key Pairs"-link on the left
- Create a pem-key pair with name 'infraxys-by-example'
- Download the file and copy the contents
- Open project "infraxys-by-example" and click the variables-tab
- Add a variable:
    - Name: `infraxys-by-example`
    - Value: paste the contents of the pem-file
    - Type: `SSH-PRIVATE-KEY`
    - Uncheck the option to export this as an environment variable and leave the other options selected.
      
## Create Infraxys resources

We'll create one role and an environment that uses this and a VPC role. 

### Create the 'AWS auth and shared configuration' role

This role:
- automatically authenticates to AWS
- contains configuration that can be shared with multiple containers and environments
- contains the necessary configuration for the VPC-role

We'll create a role with configuration needed by the VPC and future resources that will be created in the VPC. These future resources might be configured through other environments and projects.

An example of such resources is a HashiCorp Vault cluster which could be managed by another team of which users shouldn't be able to modify the VPC created here, but who do need information from it.

- Open the modules-tab in the right-slider and add a role to your practice-module using the context-menu.
- Name it 'aws-example-config' and use description 'Shared AWS configuration for vpc-example'. Click 'Save'.
- Click the Instances-tab.
- Open the Packets-element in the module-tree under the aws-core master-branch.
- Drag packet 'AWS core variables' and drop it on the root-instance of the aws-example-config's instance tree.    
    - Enter the name of the AWS profile in the credentials-field. This is the name that you used in the **value** of the AWS Credentials or Config variable (my-aws-profile or my-us-west-1-role if you didn't change the example names while configurating prerequisite 'AWS access key and secret').
    - Leave the defaults for the other attributes.
- Drag packet 'AWS VPC variables' from the aws-vpc module and drop it ON the just created 'AWS core variables' instance.
    - Prefix: `vpc-example`
    - Region: `$instance.parent.getAttribute("aws_core_region")` Note that leaving off `.parent` would give the same result because 'getAttribute' walks the tree up until it finds the attribute (after the root-instance it will check container-variables and after that environment-variables)
    - CIDR: `10.0.0.0/20`
- Drag packet 'AWS bastion variables' and drop it ON the just created 'AWS VPC variables' instance.
    - Specify the name of the ssh-key variable above (`infraxys-by-example`) and leave the other attributes as they are.
- Drag packet 'AWS core terraform bucket' and drop it on the root-instance of the aws-example-config's instance tree.
    - Region: enter the region where you created the bucket in the prerequisites-section
    - Bucket: name of the bucket
    - Folder: `${environment.name}-state`. This field is optional 
 
- Click "Save" and close the role.

### Create the VPC environment

- Open the modules-tab in the right-slider and add an environment to your practice-module using the context-menu.
- Name it 'vpc-example' and click 'Save'.
- Add a container through the context-menu of the containers-table.
- Give it name 'vpc-example' and description 'Example VPC in infraxys-by-example'. Click 'Save'. 
- Click the Roles-tab and drag the following roles from the module-tree onto the canvas (the order is important because the VPC-role would otherwise create the instances which we provide through a role). 
    - role 'aws-example-config' which we created above. This role ensures that temporary credentials are retrieved before any action is executed (you can change this behaviour, but that's out of scope here).
    - role 'VPC with private, shared and public subnet' from the AWS VPC module. This role will provide all actions needed to create and destroy the AWS resources. 

#### Add workflows to create and destroy the AWS resources

The VPC-setup consists of 2 actions:
- create elastic IP's for the NAT-instance(s)
- create the VPC with subnets and such

Creating the Elastic IP's separately allows us to delete the VPC with NAT-instances but preserve the NAT IP-addresses.

- Open the new environment
- In the Workflows-tab, add a workflow using the context-menu
- Specify 'Create AWS resources' for the name and click on the vpc-example container.
- In the "Instances and executables"-table, expand the "Static NAT IPs" instance.
- Drag action 'Terraform plan, confirm and apply' to the "Workflow steps" table (this "confirm-apply" will ask you to confirm before applying the plan)
- In the "Instances and executables"-table, expand the "AWS - VPC" instance.
- Drag action 'Terraform plan, confirm and apply' to the "Workflow steps" table. Make sure it's underneath the NAT-action because the VPC needs the IPs to be there.
- Close the workflow
- Add a second workflow called 'Destroy AWS resources' and attach the following actions to it:
    - 'Terraform plan DESTROY, confirm and apply' of the "AWS - VPC"-instance.
    - 'Terraform plan DESTROY, confirm and apply' of the "Static NAT IPs"-instance.


### Use the new environment

This environment now exist under a module only. To be able to use it, we need to attach it to a project. 
If we have multiple Infraxys installations, then we can now use this environment in as many as we wish.

- Open your 'infraxys-by-example' project in the left project-tree.
- Drag the new 'vpc-example' environment from the module-tree and drop it on this project.
- Open the environment and click the "Generate scripts" button. This will generate all files for the environment.
- Open the context-menu of the environment in the project-tree and select "Workflows -> Create AWS resources".

This will start the first action of the workflow.

If the AWS-profile requires MFA, then you'll get the option to enter it.

After planning, the action will halt and ask you to press enter to apply the Terraform plan that you can validate first.

In the text-box under the console, press enter. The NAT-EIPs will be created.

The second action automatically starts and again it will ask your confirmation before creating the VPC and sub-resources.

Press enter in the text-box under the console
 
## Cleanup 

- Open the context-menu of project 'infraxys-by-example' and select "Workflows -> Destroy AWS resources".
- You will have to confirm by typing 'DESTROY' for both actions.


## Troubleshooting

At the time of writing this, the VPC-apply failed because the NAT-instances couldn't use the IPs.

The reason was that the NAT-instance in Infraxys had value 'us-east-1' for its region while the VPC was created in eu-west-1.

I performed the following steps to fix this:
- Open container 'vpc-example' and select the instances-tab
- Under the VPC-role, right click the 'Static NAT IPs'-instance and click `actions -> Destroy -> Terraform plan DESTROY, confirm and apply`
- The script will ask to enter 'DESTROY' to confirm. After that, the elastic IPs in us-east-1 were removed
- Then I've updated the value of the region-field (on the role, it's disabled on containers) for the NAT-IPs to `$container.getAttribute("aws_vpc_region")` so it will always have the same value as the VPC.
- Click "Generate scripts" on the vpc-example container
- Run the create-workflow again

 