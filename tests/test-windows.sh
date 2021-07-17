#!/bin/sh

if [ -f requirements.yml ]; then
  ansible-galaxy install -r requirements.yml
fi

ROLE_NAME=$(sed -n 's^.*- role:\ "\(.*\)"$^\1^p' test.yml)
ln -s echo "$(basename "$PWD")" "../$ROLE_NAME"

cp tests/ansible.cfg ansible.cfg
cp tests/test.yml main.yml
ansible-playbook -i tests/inventory-windows main.yml

WINDOWS_HOST_IP=$(/sbin/ip route | awk '/default/ { print $3 }')
echo "$WINDOWS_HOST_IP"
