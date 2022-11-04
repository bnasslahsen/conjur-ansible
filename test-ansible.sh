#!/bin/bash

CONJUR_APPLIANCE_URL=https://conjur.demo.cybr:443
CONJUR_AUTHN_API_KEY=2hvd0mayxp3r19xtkbj322n1en14h9ttg3kward3bw87wb3epdh2r
CONJUR_AUTHN_LOGIN=host/cd/ansible/controller
CONJUR_CERT_FILE=conjur.pem
CONJUR_ACCOUNT=devsecops

ansible-galaxy collection install cyberark.conjur

openssl s_client -connect "$CONJUR_MASTER_HOSTNAME":"$CONJUR_MASTER_PORT" \
  -showcerts </dev/null 2> /dev/null | \
  awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/ {print $0}' \
  > "$CONJUR_CERT_FILE"

ansible-playbook -i inventory playbook.yml