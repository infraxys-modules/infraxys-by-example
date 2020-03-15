# Infraxys A to Z: 07 - Execute over SSH


In this example we will:
- Generate an SSH configuration file that you can use on your local machine.
- Create an action that executes a function on the previously created EC2 instance and that copies files automatically from and to the instance.
- Make additional Bash-functions available on the remote host by "annotating" dependencies. 


## Prerequisites

Executed the [06 - AWS EC2 instance](../06-aws-ec2-instance/README.md)-example.

## Generate SSH configuration

- Open container "vpc-example" of environment "vpc-example".
- Generate scripts for this container so that possible changes to the configuration or files are processed.
- In the Instances-tab, under "Role: VPC .../VPC Terraform runner", select the "AWS VPC - private shared and public subnets instance".
- Execute the action "Show VPC ssh config".
- The console will contain the host-blocks similar to below that you can copy to your local configuration:

```
Host vpc-example-bastion-asg
    Hostname ec2-54-154-66-228.eu-west-1.compute.amazonaws.com
    User ec2-user
    IdentityFile "~/.ssh/keys/infraxys-by-example.pem"                    
                    
       
Host atoz-instance-1
   Hostname 10.0.0.249
   User ubuntu
   ProxyCommand ssh vpc-example-bastion-asg -W %h:%p
   IdentityFile ~/.ssh/keys/infraxys-by-example.pem
            
```

Try to SSH into vpc-example-bastion-asg and atoz-instance-1:
```
ssh vpc-example-bastion-asg
ssh atoz-instance-1
```


> If this times out, then your IP-address is probably not whitelisted.  
> To fix this:
> - Retrieve your public IP from https://ipinfo.io/ip.
> - Open role 'aws-example-config' (you can do this directly from the instance tree).
> - Make sure your IP is in the SSH CIDR-block of the "AWS BASTION variables"-instance (don't forget to add "/32" to your IP-address and that all entries end with a comma except the last one).
> - Go back to the "vpc-example"-container and generate the scripts.
> - Execute action "Terraform plan, confirm and apply" of the "VPC Terraform runner"-instances. This should update the security group rules of the bastion instance.



## Create the test-packet

### Steps

First we'll create a file that our script will copy to the remote instance.

- Create packet "Execute over ssh" with instance label "Execute over ssh" under your examples-module.
- Add the following file:

| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| Label | My configuration example | |
| Filename | my-example.conf |  |

File contents: 
```
title: Example
project: Infraxys by example
```
- Save and close the file.

Next file is the action:
- Add another file:

| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| Label | Run example | |
| Filename | run-example.sh |  |
| Parse with Velocity | Selected | |
| Executable | Selected | |

File contents: 

```
remote_instance_name="$atozInstance1.getAttribute("instance_name")";

#[[
function_run_me_on_target_function_dependencies="show_dialog show_message_dialog wait_for_feedback";
function run_me_on_target() {
	local function_name="run_me_on_target" display_message;
	import_args "$@";
	check_required_arguments "$function_name" display_message;
	log_info "Displaying popup if running interactive. Otherwise displaying the message in the console.";
	if [ "$INTERACTIVE" == "true" ]; then
		show_message_dialog --message "$display_message $hostname.";
	else
		echo -e "\n\t$display_message $hostname.\n";
	fi;
	
	log_info "Contents of received configuration file '$transfer_file_remote_path':";
	cat "$transfer_file_remote_path";
	
	log_info "Creating file '$retrieve_file'.";
	cat > "$retrieve_file" << EOF
This is written
on host $hostname
by $(id -un)

IP config:

EOF

	ip addr show >> "$retrieve_file";
}

log_info "Executing function 'run_me_on_target' on the example EC2-instance.";

remote_filename="remote.txt";

execute_function_over_ssh \
    --hostname "$remote_instance_name" \
    --function_name run_me_on_target \
    --transfer_file "$INSTANCE_DIR/my-example.conf" \
    --transfer_file_remote_path "/tmp/my-example.conf" \
    --retrieve_file "/tmp/$remote_filename" \
    --retrieve_file_local_path "/tmp/retrieved_file.txt" \
    --display_message "Hello from ";
        
log_info "Back from remote execution. Retrieved file contains:";
cat "/tmp/retrieved_file.txt";
        
]]#
```

We'll go over this file in the next section.

- Save the file and close all tabs.
- Add a container to the "atoz-ec2-instances"-environment

| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| Name | Execute over SSH | |
| Description | Execute over SSH example |  |

- Save the container.
- Drop role "aws-example-config" from your example module onto the Roles-canvas of this container. This is needed to setup the AWS environment correctly.
- Drop our new "Run example"-packet on the root-instance.

We'll run the action from the script-directly instead of from the Instances-tab. This way we can make and test changes to the script wit just one button-click instead of having to save, switch tabs, generate scripts and then execute the action.

- Select "Open packet with script generation" from the context-menu of our "Execute over SSH"-instance.
- Open the "run-example.sh"-file. Add the bottom there are now additional options to generate scripts and execute the action.
- If you want to see the generated "run-example.sh"-file, then you can open it directly. It's under your Infraxys-root/environments/atoz-ec2-instances_<number>/Execute+over+SSH/Execute_over_ssh_<number> (where <number> is an arbitrary number).

## The script explained

```
remote_instance_name="$atozInstance1.getAttribute("instance_name")";
```
"atozInstance1" is the Velocity name of the Infraxys instance that contains configuration for the EC2 instance.
After script generation, this line will be `remote_instance_name="atoz-instance-1";` 
  
```
#[[
```
'#[[' indicates the start of a block that's not parsed using Velocity. This is handy because otherwise we would needs to escape characters like '$'.  
The Velocity context contains a convenience variable 'D' to generate a Dollar-sign. We would use, for example `import_args "${D}@";` in a block that is parsed by Velocity to get `import_args "$@";` in the resulting file.  

```
function_run_me_on_target_function_dependencies="show_dialog show_message_dialog wait_for_feedback";
```

When a function is executed remote, the Infraxys module checks if dependencies for it are defined and adds them if there are.  
Dependency variables have the name "function_<the executed function name>_function_dependencies". If this variable exists, then all functions in it will be available on the remote host.

```
function run_me_on_target() {
	local function_name="run_me_on_target" display_message;
	import_args "$@";
	check_required_arguments "$function_name" display_message;
	log_info "Displaying popup if running interactive. Otherwise displaying the message in the console.";
```

The first line initializes function-scope variables.  
`import_args "$@";` reads all passed arguments and will set variables, like 'display_message' to the value that was passed for that argument.  
`check_required_arguments` accepts a function-name which it uses if it needs to display errors. After the function name, you can specify one or more variable names that should have a value.  
`log_info` is, besides log_warn, log_debug, log_error and log_fatal a convenience function to send output to the console with some extra information like the host, time and user.

```
	if [ "$INTERACTIVE" == "true" ]; then
		show_message_dialog --message "$display_message $hostname.";
	else
		echo -e "\n\t$display_message $hostname.\n";
	fi;
	
	log_info "Contents of received configuration file '$transfer_file_remote_path':";
```

Environment variable 'INTERACTIVE' is always available. It is "true" if the action was started through the UI, "false" in case it was started through REST or a schedule.

`show_message_dialog` is a Bash function that outputs a FEEDBACK-block which is understood by Infraxys. See the console log of the action for its contents.

```
	cat "$transfer_file_remote_path";
	
	log_info "Creating file '$retrieve_file'.";
	cat > "$retrieve_file" << EOF
This is written
on host $hostname
by $(id -un)

IP config:

EOF

	ip addr show >> "$retrieve_file";
}
```

Variable "transfer_file_remote_path" is used by function "execute_function_over_ssh" and we have access to it from our own function as well.

Further we just write some lines to file "$retrieve_file" which resolves to "/tmp/remote.txt".

```
log_info "Executing function 'run_me_on_target' on the example EC2-instance.";

remote_filename="remote.txt";

execute_function_over_ssh \
    --hostname "$remote_instance_name" \
    --function_name run_me_on_target \
    --transfer_file "$INSTANCE_DIR/my-example.conf" \
    --transfer_file_remote_path "/tmp/my-example.conf" \
    --retrieve_file "/tmp/$remote_filename" \
    --retrieve_file_local_path "/tmp/retrieved_file.txt" \
    --display_message "Hello from ";
        
log_info "Back from remote execution. Retrieved file contains:";
cat "/tmp/retrieved_file.txt";
        
]]#
```

`execute_function_over_ssh` is a function provided by the Infraxys module. It accepts the arguments that we see here and it forwards all custom arguments to the function we want to call.  
`]]#` marks the end of the Velocity comment-block. This character won't be in the parsed file.



