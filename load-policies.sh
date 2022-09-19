#!/bin/bash

set -a
source ".env"
set +a

ansible-galaxy collection install cyberark.conjur

openssl s_client -connect "$CONJUR_MASTER_HOSTNAME":"$CONJUR_MASTER_PORT" \
  -showcerts </dev/null 2> /dev/null | \
  awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/ {print $0}' \
  > "$CONJUR_SSL_CERTIFICATE"

export CONJUR_AUTHN_API_KEY=g2rrnw3bgpa643hyp22w1vfyb6f3esfaze1dsh8nj3yxs0j2p35qqn
export CONJUR_AUTHN_LOGIN=host/cd/ansible/controller

#conjur policy update -b root -f ansible-host.yml
#conjur policy update -b root -f ansible-secrets.yml
#conjur variable set -i cd/ansible/secrets/nginx_private_key -v "toto"

ansible-playbook -i inventory playbook.yml