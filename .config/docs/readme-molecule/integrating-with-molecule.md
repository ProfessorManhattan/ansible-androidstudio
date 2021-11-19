### Integrating with Ansible Molecule

If you are using this image for testing [Ansible roles]({{ repository.group.ansible_roles }}) using [Ansible Molecule]({{ website.ansible_molecule_docs }}), then you will have to incorporate the image into your `molecule.yml` file (as well as have the appropriate folder structure in your custom role). A great example is in the repository of our [Android Studio Ansible role]({{ repository.project.androidstudio }}). In that role's root directory, you will see a folder named `molecule/` alongside a properly structured Ansible role. In that folder, you will see a folder named `docker/`. This folder defines the "docker" Molecule scenario. In the `molecule/docker/` folder, you will see a file called `molecule.yml` which you can open to see a reference to this repository's Docker Hub slug (i.e. `megabytelabs/{{ slug }}`). Once you have everything setup like it is in our Android Studio role, you can run `molecule test -s docker` to run the tests.

#### `molecule.yml` Example

At the minimum, your `molecule/docker/molecule.yml` should look something like this:

```yaml
---
dependency:
  name: galaxy
  options:
    role-file: requirements.yml
    requirements-file: requirements.yml
driver:
  name: docker
platforms:
  - name: MyMoleculePlatform
    image: megabytelabs/{{ slug_full }}:latest
    command: ''
    tmpfs:
      - /run
      - /tmp
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    privileged: true
    pre_build_image: true
provisioner:
  name: ansible
  connection_options:
    ansible_connection: docker
    ansible_password: ansible
    ansible_ssh_user: ansible
  playbooks:
    converge: converge.yml
verifier:
  name: ansible
scenario:
  test_sequence:
    - lint
    - dependency
    - cleanup
    - destroy
    - syntax
    - create
    - prepare
    - converge
    - idempotence
    - side_effect
    - verify
    - cleanup
    - destroy
```

#### `converge.yml` Example

The above configuration defines a custom `converge.yml` file. The `converge.yml` file is meant to contain the playbook or role logic; it is where you define what to install with your role. You can see a working format of `converge.yml` below or in the aforementioned [Android Studio role]({{ repository.project.androidstudio }}) repository.

```yaml
---
- name: Converge
  hosts: all
  vars:
    ansible_user: ansible
  roles:
    - role: androidstudio
```

#### Additional Information on Ansible Molecule

If you are getting started with Ansible or Molecule, then you might find the information in the Android Studio role's [README.md]({{ repository.project.androidstudio }}/-/blob/master/README.md) and [CONTRIBUTING.md]({{ repository.project.androidstudio }}/-/blob/master/CONTRIBUTING.md) helpful. Also, if you are interested in seeing our flagship Ansible product (which is an Ansible playbook intended to provision development-oriented desktops and production-quality servers), then please check out [{{ repository_title.playbooks }}]({{ repository.playbooks }}).
