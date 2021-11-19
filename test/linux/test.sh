#!/usr/bin/env bash

# @file test/linux/test.sh
# @brief A script used to test Ubuntu ARM on Travis CI and possibly other scenarios

# Ensure Ansible is installed
if ! type ansible &> /dev/null; then
  pip3 install ansible
fi

# Ensure Ansible Galaxy dependencies are installed
if [ -f requirements.yml ]; then
  ansible-galaxy install -r requirements.yml
fi

# Symlink the Ansible Galaxy role name to the working directory one level up
ROLE_NAME="$(grep "role:" test/linux/test.yml | sed 's^- role: ^^' | xargs)"
ln -s "$(basename "$PWD")" "../$ROLE_NAME"

# Copy required files and run the Ansible play
cp test/linux/ansible.cfg ansible.cfg
cp test/linux/test.yml test.yml
ansible-playbook -i test/linux/inventory test.yml
