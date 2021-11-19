## Managing Environments

We accomplish managing different environments by symlinking all the folders that should be unique to each network environment (e.g. `host_vars/`, `group_vars/`, `inventories/`, `files/vpn/`, and `files/ssh/`). In the `environments/` folder, you will see multiple folders. In our case, `environments/dev/` contains sensible configurations for testing the playbook and its' roles. The production environment is a seperate git submodule that links to a private git repository that contains our Ansible-vaulted API keys and passwords. When you are ready to set up your production configurations, you can use this method as well. But if you are just starting off, you do not have to worry about this since, by default, this playbook is configured to run with the settings included in the `/environments/dev/` folder.

### Quick and Easy Way

If you have Task installed (or already ran `bash .start.sh` which installs Task if it is missing from your system), you can switch environments with an interactive prompt by running:

```
task ansible:environment
```
