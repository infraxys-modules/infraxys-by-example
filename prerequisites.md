# Prerequisites

You have an <a target="_blank" href="https://github.com/infraxys-core/infraxys-developer">Infraxys Developer Edition</a> running.
The examples assume that you will follow them step-by-step. If this is the case, then a GitHub-repository should be created as well.

## Setup your environment

Most examples assume that the following configuration is already in place.

## GitHub module repository setup

If you want to perform the steps from the examples yourself, then you need to create a module in GitHub.
See <a href="https://infraxys.io/topics/using-modules/" target="_blank">Infraxys modules</a> on how to setup your module repository.

### Infraxys container setup
- Create environment "examples" under the "Environments"-node of your module.
- Create container "examples" in the containers-tab of the details view for the environment. Use description "infraxys-by-example".
- In the project-tree on the left, create project "infraxys-by-example" underneath a project of your choice.
- Drag the "examples" environment and drop it on this project. 

## Setup this infraxys-by-example module

If you're not creating the packets and such in your own GitHub-repository, then you'll need configure this repository to be able to run the examples:

* infraxys-by-example is normally already in your module-list. In case not:
- Open the Modules-tab in the right slider.
- Right-click in the Module-tree and select "Add module".
- Specify `https://github.com/infraxys-modules/infraxys-by-example.git` for Module URL.
- No need to specify an SSH key or token here since we're not going to modify this module.
- Click the "Save >"-button. Infraxys will retrieve the branches from the module.
- Right-click the master-branch and select the import option. 
    - -> Infraxys will import all available packets, roles and environments. For the infraxys-by-example module and all modules that it depends on.
- Click "Finish".

When new examples are added, you can import them through the "Git"-context-menu of this master-branch.
It's best to always include dependencies when manually pulling from Git.

