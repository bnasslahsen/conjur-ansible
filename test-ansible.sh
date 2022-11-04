#!/bin/bash

CONJUR_MASTER_HOSTNAME=conjur.demo.cybr
CONJUR_MASTER_PORT=3000
export CONJUR_APPLIANCE_URL=https://$CONJUR_MASTER_HOSTNAME:$CONJUR_MASTER_PORT
export CONJUR_AUTHN_API_KEY=$ANSIBLE_KEY
export CONJUR_AUTHN_LOGIN=host/cd/ansible/controller
export CONJUR_CERT_FILE=conjur.pem
export CONJUR_ACCOUNT=devsecops

ansible-galaxy collection install cyberark.conjur

openssl s_client -connect "$CONJUR_MASTER_HOSTNAME":"$CONJUR_MASTER_PORT" \
  -showcerts </dev/null 2> /dev/null | \
  awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/ {print $0}' \
  > "$CONJUR_CERT_FILE"

ansible-playbook -i inventory playbook.yml