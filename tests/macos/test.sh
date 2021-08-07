#!/usr/bin/env bash

# @file tests/macos/test.sh
# @brief A script that is used to test the role's macOS compatibility via a [GitHub action](https://gitlab.com/megabyte-labs/common/ansible/-/blob/master/files-role/.github/workflows/macOS.yml).

# Ensure Ansible is installed
if ! type ansible &> /dev/null; then
  pip3 install ansible
fi

# Ensure Ansible Galaxy dependencies are installed
if [ -f requirements.yml ]; then
  ansible-galaxy install -r requirements.yml
fi

# Symlink the Ansible Galaxy role name to the working directory one level up
ROLE_NAME="$(grep "role:" tests/macos/test.yml | sed 's^- role: ^^' | xargs)"
ln -s "$(basename "$PWD")" "../$ROLE_NAME"

# Copy required files and run the Ansible play
cp tests/macos/ansible.cfg ansible.cfg
cp tests/macos/test.yml test.yml
ansible-playbook -i tests/macos/inventory test.yml
