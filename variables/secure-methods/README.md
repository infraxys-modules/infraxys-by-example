# Securing methods using variables

See <a href="https://infraxys.io/concepts/resource-types/variable/" target="_blank">Infraxys Variables</a> for more information.

Variables can be created at the project, environment and container level. This means that blocking a function can be managed at a higher project then the root-project of a user.

This example shows how to block the execution of a method in Bash, but the same procedure can be used for any other language.

## Prerequisites

See the prerequisites-section of [here](../../README.md)


## 1. Create the variable

Open the "infraxys-by-example"-project in Infraxys and click the "Variables"-tab.  
Right-click in the space below the tab and select "Create item".

Set the following values:
- uncheck "Protect value". This allows users to change and view the variable later.
- uncheck "Export as environment variable". Environment variables can be overwritten, so using the variable this ways is insecure.
- uncheck "Allow overrides". The variable cannot be overridden in any sub-project, environment or container.
- check "Save to file". A readonly file with the name of the variable will be available in a variables-directory.

![variable](resources/variable.png "Creating a variable")

## 2. Create the packet (optional)

> Follow this part if you're using your own module repository.   

- Open the modules-tab in the right-slider and add a packet to your practice-module:
![add packet](resources/add-packet.png "Add packet")

- Specify the following details and save the packet.
![packet](resources/packet-form.png "Add packet")

- Click the "Files"-tab and add a file through the context-menu for the space below the tab. Make sure "Executable" is selected.

![script](resources/script.png "Script")
```bash
#!/usr/bin/env bash

set -euo pipefail;

BLOCK_FILE="/tmp/infraxys/variables/SEC_BLOCK_MODIFICATIONS";

function i_dont_modify() {
	log_info "It's ok to run i_dont_modify.";
}

function i_modify() {
	log_info "Checking if it's ok to run i_modify.";
	[[ -f "$BLOCK_FILE" ]] \
		&& log_error "You are not allowed to execute this method!" \
		&& exit 1;
	
	log_info "File $BLOCK_FILE doesn't exist, so modification is OK";
}

i_dont_modify;
i_modify;
```

The path shouldn't contain variables because they could be overwritten.
- Create an environment under the project with the variable.
- Create a container under the project.
- Click the "Instances"-tab after saving the container.
- Drag the new packet from the Modules-tree onto the root instance of the container.
- Click save.
- Click "Generate scripts".
- Right-click on the new packet and execute the action:
![execute](resources/execute-action.png "Execute action")
 
