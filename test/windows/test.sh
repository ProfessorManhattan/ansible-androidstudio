#!/usr/bin/env bash

# @file test/windows/test.sh
# @brief A script that is used to test an Ansible role on Windows from a WSL environment (or possibly Docker)
#
# @description This script is intended to be run in a WSL environment on a Windows host to provision the Windows
# host via Ansible using WinRM and CredSSP.

TEST_TYPE='windows'

# @description Ensure Ansible is installed along with required dependencies
pip3 install ansible 'pywinrm[credssp]'

# @description Ensure Ansible Galaxy dependencies are installed
if [ -f requirements.yml ]; then
  ansible-galaxy install -r requirements.yml
fi

# @description Symlink the Ansible Galaxy role name to the working directory one level up
ROLE_NAME="$(grep "role:" test/windows/test.yml | sed 's^- role: ^^' | xargs)"
ln -s "$(basename "$PWD")" "../$ROLE_NAME"

# @description Back up files and then copy replacements (i.e. ansible.cfg)
function backupAndCopyFiles() {
  if [ -f ansible.cfg ]; then
    cp ansible.cfg ansible.cfg.bak
  fi
  cp "test/$TEST_TYPE/ansible.cfg" ansible.cfg
}

# @description Restores files that were backed up (i.e. ansible.cfg)
function restoreFiles() {
  if [ -f ansible.cfg.bak ]; then
    mv ansible.cfg.bak ansible.cfg
  fi
}

# @description Calls [restoreFiles] and exits with an error
function restoreFilesAndExitError() {
  restoreFiles
  exit 1
}

# @description Silence error about ansible.cfg being writable
export ANSIBLE_CONFIG="$PWD/ansible.cfg"

# @description Back up files, run the play, and then restore files
backupAndCopyFiles
ansible-playbook -i "test/$TEST_TYPE/inventory" "test/$TEST_TYPE/test.yml" || restoreFilesAndExitError
restoreFiles
