#!/bin/bash

set -a
source ".env"
set +a

ansible-galaxy collection install cyberark.conjur

conjur policy update -b root -f ansible-host.yml
conjur policy update -b root -f ansible-secrets.yml

conjur variable set -i cd/ansible/secrets/nginx_private_key -v "toto"

conjur logout > /dev/null 2>&1
conjur login -i admin -p "$CONJUR_ADM_PWD" > /dev/null 2>&1
cp $HOME/.netrc "$SCRIPT_DIR/demobook/.netrc"
sed -i "1 s|$|/authn|" "$SCRIPT_DIR/demobook/.netrc"
envsubst < "$SCRIPT_DIR/demobook/playbook.yml" > "$SCRIPT_DIR/demobook/playbook.tmp.yml"
CONJUR_IDENTITY_FILE="$SCRIPT_DIR/demobook/.netrc" ansible-playbook -i inventory playbook.tmp.yml
rm -f "$SCRIPT_DIR/demobook/.netrc" "$SCRIPT_DIR/demobook/playbook.tmp.yml"
conjur logout > /dev/null 2>&1
cd - > /dev/null