#!/bin/sh

if [ -f requirements.yml ]; then
  ansible-galaxy install -r requirements.yml
fi

ROLE_NAME=$(sed -n 's^.*- role:\ "\(.*\)"$^\1^p' tests/test.yml)
ln -s "$(basename "$PWD")" "../$ROLE_NAME"

python3 -m pip install requests-credssp

cp tests/ansible.cfg ~/.ansible.cfg
cp tests/test.yml main.yml
ansible-playbook -i tests/inventory-windows main.yml
