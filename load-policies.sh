#!/bin/bash

set -a
source ".env"
set +a

ansible-galaxy collection install cyberark.conjur

openssl s_client -connect "$CONJUR_MASTER_HOSTNAME":"$CONJUR_MASTER_PORT" \
  -showcerts </dev/null 2> /dev/null | \
  awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/ {print $0}' \
  > "$CONJUR_SSL_CERTIFICATE"

conjur policy update -b root -f ansible-host.yml
conjur policy update -b root -f ansible-secrets.yml

conjur variable set -i cd/ansible/secrets/nginx_private_key -v "toto"

ansible-playbook -i inventory playbook.yml