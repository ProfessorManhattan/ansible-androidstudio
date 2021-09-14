#!/usr/bin/env bash

# @file tests/ubuntu/test.sh
# @brief A script used to test Ubuntu ARM on Travis CI

# Ensure Ansible is installed
if ! type ansible &> /dev/null; then
  pip3 install ansible
fi

# Ensure Ansible Galaxy dependencies are installed
if [ -f requirements.yml ]; then
  ansible-galaxy install -r requirements.yml
fi

# Symlink the Ansible Galaxy role name to the working directory one level up
ROLE_NAME="$(grep "role:" tests/ubuntu/test.yml | sed 's^- role: ^^' | xargs)"
ln -s "$(basename "$PWD")" "../$ROLE_NAME"

# Copy required files and run the Ansible play
cp tests/ubuntu/ansible.cfg ansible.cfg
cp tests/ubuntu/test.yml test.yml
ansible-playbook -i tests/ubuntu/inventory test.yml
