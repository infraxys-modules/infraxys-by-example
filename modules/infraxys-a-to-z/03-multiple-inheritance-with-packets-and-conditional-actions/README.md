# Infraxys A to Z: 03 - Multiple inheritance with packets and optional action generation

A packet can inherit files from one or more other packets using the "Extends packets"-tab in the packet-view.  
Inheritance can go multiple levels deep and multiple packets can be extended at the same time.  
 
In this example we will:
- Create a new packet that has its own files and attributes + inherited files and attributes
- Explain how you can conditionally avoid the creation of an action or (part of) a file
   
## Prerequisites

Executed the [02 - Using Apache Velocity and scoped attributes](../02-velocity-attributes/README.md)-example.

## Steps

### Packet details

- Add a packet under your exercise-module.

| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| Name | Display message - inherited | |
| Instance label | Inherit example |  |

- Save the packet and open the "Extends packets"-tab.
- Drag and drop packet "Display message" from the module-tree onto the table under the "Extends packets"-tab.
 

The scripts we're inheriting expect attribute "display_message" to exist. To add this, we'll copy it from the "Display message" packet:
- Open the "Display message"-packet.
- Copy the "display_message"-attribute using the context-menu of the "Attributes"-table.
- Open the "Attributes"-tab of the just created "Display message - inherited" packet.
- Right-click in the "Attributes"-table and select "Paste".

### Container setup

- Create a new container "Packet inheritance" with description "Packet inheritance example" under the "AtoZ"-environment.
- Drop above packet on the root-instance and generate the scripts

You'll see that the new instance has the 2 actions that come from the inherited packet.

## Inherited actions

Note that the inherited files are generated in the context of this new instance and so can use and require certain attributes to exist using Velocity.

An action can be created conditionaly as is done for ["Terraform apply"](https://github.com/infraxys-modules/terraform/blob/master/packets/Terraform%20Helper/files/terraform_apply.sh):

The "Terraform apply"-file has Velocity enabled. It gets the value of attribute "skip_terraform_action_creation" and if this value exists and has the value "1" (selected checkbox), then it will instruct Infraxys to not create an action.
The file is fully generated still. If you want to avoid this, then add `#stop` at the end of the if-block. The rest of the file will then be ignored.  

```bash
#if ($instance.getParentInstanceByAttributeValue("skip_terraform_action_creation", "1", false))
	#set ($skip_action_creation = true)
#end

#[[
cd "$TERRAFORM_TEMP_DIR";
terraform_apply;
]]#
``` 