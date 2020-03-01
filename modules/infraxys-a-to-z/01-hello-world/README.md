# Infraxys A to Z: Hello World

In this example we will:
- Add packet "Display message" to our personal Infraxys module.
- Make the instance label dynamic.
- Add attribute "display_message" with a tooltip.
- Add a script to display the value of the attribute in the console.
- Add a script to display the value of the attribute in a popup dialog.
- Create sub-project "Example modules" under our Examples-project.
- Create version-controlled environment "AtoZ" and attach it to the new project.
- Create container "Part 1".
- Create an instance of our new packet on this container.
- Generate scripts so that actions are generated.
- Execute the "Display message"-action.
- Execute the "Display popup"-action.
   
## Prerequisites

See the [prequisites](./prerequisites.md)-page.

## Steps

### Packet details

- Open the Modules-tab in the right Utils-slider.
- Select "Add packet" from the context-menu of the "Packets"-item under your exercise-module.

| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| Name | Display message | |
| Instance label | Message: %display_message% | Instances of this packet will have a label "Display " and then the value of the 'display_message'-attribute |
| Info html | ```<h2>Display message</h2><p><a target="_blank" href="https://github.com/infraxys-modules/infraxys-by-example/modules/infraxys-a-to-z/01-hello-world/README.md">Open the instructions</a></p>``` | This will be displayed in the instance-screens for this packet. Be sure to specify '_blank' for the target, otherwise the current Infraxys-page will be replaced when the user presses this. |

- Click the Save-button.

### display_message attribute

- Right click in the open space under the "Attributes"-tab.
- Select "Add attribute" from the context-menu.

| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| Attribute | display_message | |
| Caption | | Display message |
| Type | Text (one line) | |
| Required | Checked | |
| Input prompt | <Enter a message here> | |
| Tooltip | ```<h2>Display message</h2><p>Enter the message to display.</p>``` | This will be the tooltip when a user hovers over this attribute |

- Click the Save-button.

### Display message and Display popup scripts

- Click the "Files"-tab.
- Add file:


| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| Label | Display message | This is the text displayed in the action menus |
| Filename | display-message.sh | |
| Executable | Checked | |
| File | `echo "$display_message"` | Attributes of the current packet are available in the environment. |

- Click the Save-button and close the file-tab.
- Add a second script:

| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| Label | Display popup |  |
| Filename | display-popup.sh | |
| Executable | Checked | |
| Menu order | 200 | Make sure it's displayed after "Display message" in the actions menu |
| Seperator before | Checked | Add a line before this action in the actions menu |
| File | `show_dialog --title "My custom message" --message "$display_message"` | This will use the "<FEEDBACK>"-mechanisme to let Infraxys open a popup in the user's browser. |

- Click the Save-button and close the tab.
- Close the Packet-tab.

## Create an instance of the packet

- Right-click on your "infraxys-by-example"-project which you've created as part of the initial prerequisites.
- Select "Add project", name it "Example modules", click "Save" and close the project-tab.
- Right-click this new "Example modules"-project in the left project-tree and select "Add environment".
- In the right module-slider, under the module where you created the "Display message"-packet, right-click the "Environments" item and select "Add environment".
- Specify "AtoZ" for the name and click "Save".
- In the containers-tab, add a new container using the context-menu.

| Attribute | Value | Remark |
| :-------- | :---- | :----- |
| Name | Part 1 |  |
| Description | First part of the Infraxys "AtoZ"-example | |

- Click Save.
- Click the "Instances"-tab.
- Drag our new packet "Display message" from the module-tree and drop it on the root instance (label "Part 1 - First ....")
- In the dialog, there's the "Open the instructions"-link which will open in a new tab when clicked.
- Enter "Hello world" in the "Display message"-field.
- Click Save. We've now created an instance, but not yet the actions. For this, the environment needs the be part of a project.
- Close all tabs.
- Drag environment "AtoZ" from the modules-tree and drop it on the project "Example modules" which we've created above.
- Click environment "AtoZ" in the project tree to ensure the container is displayed in the bottom list.
- Double click the container.
- The container details will show a "Generate scripts"-button. If not, close the container and re-open it.
- Click the "Generate scripts"-button. This will store the files on the provisioning server (which is your local pc for Infraxys Developer). For files marked executable, an actions will be created.
- Click the "Instances"-tab.
- Right-click on the "Message: Hello world"-instance
    - Both the actions-context menu and the bottom menu will contain the 2 actions
- Click "Display message" in either of the menu's
    - Infraxys will start a Docker container to prepare the executions
    - Infraxys will then start the default provisioning-container, enable all referenced modules and execute the action. See [execution-order](https://infraxys.io/topics/execution-order/) for more details.
    - Finally the message, specified in the instance, will be displayed in the console.
- Click "Display popup"

