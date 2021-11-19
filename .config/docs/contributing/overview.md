## Overview

All our Dockerfiles are created for specific tasks. In many cases, this allows us to reduce the size of the Dockerfiles by removing unnecessary files and performing other optimizations. [Our Dockerfiles]({{ repository.group.dockerfile }}) are broken down into the following categories:

- **[Ansible Molecule]({{ repository.group.dockerfile_ansible_molecule }})** - Dockerfile projects used to generate pre-built Docker containers that are intended for use by Ansible Molecule
- **[Apps]({{ repository.group.dockerfile_apps }})** - Full-fledged web applications
- **[CI Pipeline]({{ repository.group.dockerfile_ci }})** - Projects that include tools used during deployments such as linters and auto-formatters
- **[Software]({{ repository.group.dockerfile_software }})** - Docker containers that are meant to replace software that is traditionally installed directly on hosts
