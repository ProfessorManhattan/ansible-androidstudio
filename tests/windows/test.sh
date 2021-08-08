#!/usr/bin/env bash

# @file tests/windows/test.sh
# @brief A script that is used to test an Ansible role on Windows from a Docker container.
#
# @description
# This script is intended to be run by a Docker container on a Windows host to provision the Windows
# host via Ansible (which is installed on the Docker container). It is also intended to be used in a
# GitLab CI task that uses a Windows shared runner. For more information, see the
# [PowerShell script that launches Docker which, in turn, calls this script](https://gitlab.com/megabyte-labs/common/ansible/-/blob/master/files-role/tests/windows/test.ps1).

# Ensure Ansible is installed
if ! type ansible &> /dev/null; then
  pip3 install ansible pywinrm
fi

# Ensure Ansible Galaxy dependencies are installed
if [ -f requirements.yml ]; then
  ansible-galaxy install -r requirements.yml
fi

# Symlink the Ansible Galaxy role name to the working directory one level up
ROLE_NAME="$(grep "role:" tests/windows/test.yml | sed 's^- role: ^^' | xargs)"
ln -s "$(basename "$PWD")" "../$ROLE_NAME"

# Copy required files and run the Ansible play
cp tests/windows/ansible.cfg ansible.cfg
cp tests/windows/test.yml test.yml
ansible-playbook -i tests/windows/inventory test.yml
