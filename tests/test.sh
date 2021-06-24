#!/bin/bash

pip3 install ansible
if [ -f requirements.yml ]; then ansible-galaxy install -r requirements.yml; fi
cp tests/ansible.cfg ansible.cfg
cp tests/test.yml main.yml
sed -i '.bak' "s^{{PROJECT_FOLDER_NAME}}^$(basename "$PWD")^g" main.yml
ansible-playbook -i tests/inventory main.yml
