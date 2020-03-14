# Infraxys A to Z: 04 - Create a role

Roles are used to share information and actions with multiple containers in one or many environments.
 
In this example we will:
- Create a role with a "Container scoped attribute"-instance
- Inherit this role on a container and use the value of the container-level attribute.


## Prerequisites

Executed the [03 - Inheriting files and optional action generation](../03-inheriting-files-and-conditional-actions/README.md)-example.

## Steps

### Create role

- Click "Add role" in the context-menu of the "Roles"-item under your own example module.

| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| Name | role-with-container-scoped-attribute | |
| Instance label | Role example |  |

- Drop packet 'Container scoped attribute' on the root-instance of the role 
- Specifiy `This comes from the role` for "Container message"
- Close all tabs.

### Container inheriting the role

Create a new container under the "AtoZ"-environment:

| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| Name | test-role-with-container-scoped-attribute | |
| Instance label | Inherit role example |  |

- Click the "Roles"-tab and drop the new role on the empty canvas.
- Click the "Instances"-tab. You'll see the role is part of the tree now. 
- Drop the "Velocity example"-packet on the root-instance of the container.
- Specify '$container.getAttribute("container_message")' for `Display message`.
- Save and generate the scripts for the container.
- Click on the just created Message-instance and execute one of the actions. You'll see that the message from the role is displayed.

If the message is ".getAttribute("container_message")", then this means that the checkbox for Velocity-parsing is not selected on the "Velocity example"-packet.  

We can also reverse what we've done: add a container-scoped variable on the container and use that from the role.
