## Dependencies

Most of our roles rely on [Ansible Galaxy]({{ profile_link.galaxy }}) collections. Some of our projects are also dependent on other roles and collections that are published on Ansible Galaxy. Before you run this role, you will need to install the collection and role dependencies, as well as the Python requirements, by running:

```yaml
pip3 install -r requirements.txt
ansible-galaxy install -r requirements.yml
```

Alternatively, you can simply run `bash .start.sh` if you are new to Ansible and do not mind the development requirements also being installed.

### Galaxy Roles

Although most of our roles do not have dependencies, there are some cases where another role has to be installed before the logic can continue. At the beginning of the play, the Ansible Galaxy role dependencies listed in `meta/main.yml` will run. These dependencies are configured to only run once per playbook. If you include more than one of our roles in your playbook that have dependencies in common then the dependency installation will be skipped after the first run. Some of our roles also utilize helper roles directly from the task files which helps keep our [main playbook]({{ repository.playbooks }}) DRY.

The `requirements.yml` file contains a full list of the Ansible Galaxy dependencies required by this role (i.e. `meta/main.yml` role dependencies, helper roles, collections, etc.). For your convenience, a list of the role dependencies along with quick descriptions is below:

{{ role_dependencies }}
