# Infraxys A to Z: 06 - AWS EC2 instance

We'll create an EC2-instance for future exercises.
 
In this example we will:
- Create an EC2-instance using infraxys-aws modules.



## Prerequisites

Executed the [05 - Create a VPC in AWS](../05-aws-vpc/README.md)-example.

## Steps

- Add project "AtoZ - AWS" under your examples-project.
- Click "Save".
- Select environment "vpc-example" under the "infraxys-by-example"-project.
- Drag container "vpc-example" and drop it in the "Included for this project and its children"-table. This makes the vpc-container configuration available to all environments under this project. We need this for the Terraform state.
- Create a new environment "atoz-ec2-instances" under your personal examples-module in the module-tree.
- Attach this environment to the "AtoZ - AWS"-project.
- Add container 'atoz-ec2-instance-1' with description 'First EC2 instance for the AtoZ examples' to this environment.
- Drop role "github.com\infraxys-modules\infraxys-by-example\master\aws-example-config" from the module-tree on the canvas of the roles-tab of this new container.
- Drop packet 'github.com\infraxys-modules\terraform\master\terraform aws runner' from the Module-tree onto the root-instance of this container.

| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| Label | atoz-ec2-instance-1 | |
| AWS provider version | Leave the default value as is |  |
| State Velocity names | terraformVpcState | This is the Velocity name of the S3-state instance of the VPC role that we inherited through the new project. |
| Region | $container.getAttribute("aws_vpc_region") | |

- Drop packet "github.com\infraxys-aws\aws-ec2\master\ec2 instance" onto the new "terraform aws runner"-instance.

| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| Velocity name | atozInstance1 | We want to easily access this instance later |
| Name | atoz-instance-1 | |
| AMI or Packer instance | ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-202* | We'll use the latest AMI in the VPC region with a name that starts with this value. |
| AMI owners | 099720109477 | Canonical. |
| VPC Velocity name | vpc | |
| Instance type | t2.micro | |
| Key pair name | infraxys-by-example | This is the key pair we created in the aws-vpc exercise. We could create a new key pair and make it available through a variable in a parent project. |
| Subnet id | data.terraform_remote_state.vpc.outputs.private_subnets[0] | The VPC state is included by the "Terraform AWS runner"-packet. |
| Prevent destroy | unselected | We want to be able to easily remove this instance. |

- Drop packet "github.com\infraxys-aws\aws-ec2\master\security group" onto the new "ec2 instance"-instance.

| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| Name | ${container.name}-sg | |
| Description | Security group for the first a-to-z instance  | |

We'll leave the other settings as is because we only need to connect to the instance using SSH through the bastion host.

- Drop packet "github.com\infraxys-modules\terraform\master\terraform s3 remote state" onto the "terraform aws running instance"-instance (atoz-ec2-instance-1).

| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| State name | $container.name | |
| Bucket | $container.getAttribute("aws_core_s3_state_bucket")  | |
| State key | $container.getAttribute("aws_core_s3_state_folder")/${container.name}.tfstate | |
| Encrypt | selected | |

If the VPC-resources are not yet created, then first run workflow "Create AWS resources" of the "vpc-example"-environment.

- Generate scripts for this container.
- Start action "Terraform plan, confirm and apply" of the "atoz-ec2-instance-1"-instance. Terraform will show what will be changed after which you can confirm the plan.

