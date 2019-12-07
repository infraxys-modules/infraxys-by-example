# Dynamic lists

See [Attributes](https://infraxys.io/concepts/resource-types/packet/attribute/) for more information.

There are two ways to populate instance dropdowns dynamically:
* A script of the packet
* A Docker container

## Preparation

1. Create a new packet under your exercise module in the Infraxys module explorer.
1. Give it the name `dynamic-list-attributes` and label `Dynamic list attributes`. Click save.


## Attribute with values from a script

1. Create an attribute in the "Attributes"-tab with the following attribute values:
    - Name: `ec2_regions`
    - Caption: `EC2 regions`
    - Type: `Text (one line)`
    - Source: `Script Output`
    - Cache minutes: `5`
    - Reference filter: `get_ec2_regions.sh`
1. We'll leave field "Ref. value attribute" empty. You can specify a Docker image tag here if you want to use another image. By default it's the full provisioning server image.
1. Save and close the attribute.
1. Create a file with the following attribute values:
    - label: `get_ec2_regions.sh` (this won't be used if we don't make the script executable)
    - Filename: `get_ec2_regions.sh` (this is referenced in the attribute above)
    - File contents: 
    ```bash 
    curl -s https://raw.githubusercontent.com/jeroenmanders/data/master/aws/ec2_regions.json | jq -r '.Regions[] | .RegionName';
   ```
1. Save and close the file.
1. Open the "infraxys-by-example"-environment in the project-tree on the left.
1. Open the "examples" container and activate the instances-tab.
1. Drag the new "dynamic-list-attributes"-packet from the module tree onto the root-instance.
1. After a few seconds, the new instance opens and the EC2 regions-dropdown contains a list of AWS EC2 regions.
1. Close the instance 

## Attribute with values from a custom Docker image

### Create a custom Docker image
 
These steps assume that you're running Infraxys Developer and that we build the Docker image locally. The image can be uploaded to an image registry as well.  

1. Download the files under [resources](resources) to your local machine when following this page online.
1. cd into the resources directory.
1. Run the following command: `docker build -t infraxys-by-example-dynamic-list:0.1 .`.
1. The result should be a local Docker image. Not the you can create any Docker image. You could, for example, create images to download data from a REST-API, database, ....

### Create the attribute

1. Add a second attribute to the packet above with the following attribute values:
    - Name: `docker_attribute`
    - Caption: `Docker attribute`
    - Type: `Text (one line)`
    - Source: `Docker run`
    - Cache minutes: `5`
    - Reference filter: `infraxys-by-example-dynamic-list:0.1` # this is the custom image built above
1. We'll leave field "Ref. value attribute". You can add a list of extra items here, separated by `\r\n`.
1. Save and close the file.
1. Open the "dynamic-list-attributes"-instance which was created above.
1. After a few seconds, the form should be showed with the results of both the script and this Docker container.

The loading of the form is much faster the second time because we cache the lists for 5 minutes. This means no script or container has to run if the cached items aren't expired.


 

