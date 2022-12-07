#!/bin/bash

set -a
source ".env"
set +a

openssl s_client -connect "$CONJUR_MASTER_HOSTNAME":"$CONJUR_MASTER_PORT" \
  -showcerts </dev/null 2> /dev/null | \
  awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/ {print $0}' \
  > "$CONJUR_CERT_FILE"

conjur policy update -b root -f ansible-policies.yml
conjur variable set -i cd/ansible/secrets/test-password -v "toto"
conjur variable set -i cd/ansible/secrets/ansible-key -v "toto"
