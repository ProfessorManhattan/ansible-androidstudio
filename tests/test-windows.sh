#!/bin/sh

if [ -f requirements.yml ]; then
  ansible-galaxy install -r requirements.yml
fi

pip3 install "pywinrm>=0.3.0"

ROLE_NAME=$(sed -n 's^.*- role:\ "\(.*\)"$^\1^p' test.yml)
ln -s $(basename $PWD) ../$ROLE_NAME

cp tests/ansible.cfg ansible.cfg
cp tests/test.yml main.yml
ansible-playbook -i tests/inventory-windows main.yml
