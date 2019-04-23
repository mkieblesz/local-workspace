#!/bin/bash

if [ -f fixtures/dump.json ]; then
    echo "Fixtures are already present on your local machine. Exiting."
    echo
    exit 0
fi

if [ -z $CF_USERNAME ] || [ -z $CF_PASSWORD ]; then
    echo "You need to export cloudfoundry login credentials. Exiting."
    exit 1
fi

# login to cloud foundry directory-dev space
cf login -u $CF_USERNAME -p $CF_PASSWORD -s directory-dev
cf ssh directory-cms-dev -c "deps/0/bin/python3.6 app/manage.py dumpdata  --indent 4 > dump.json"

# scp dump back fixtures/dump.json to local by following instructions from link below
# https://docs.cloudfoundry.org/devguide/deploy-apps/ssh-apps.html#-app-ssh-access-without-cf-cli

GUID=$(cf app directory-cms-dev --guid)
SSH_ENDPOINT=$(cf curl /v2/info | jq -r .app_ssh_endpoint | cut -f1 -d":")
VERSION=$(cf curl /v2/info | jq -r .version)
# get single use access code which will be passed to scp
sshpass -v -p $(cf ssh-code) scp -P 2222 -o User=cf:$GUID/$VERSION $SSH_ENDPOINT:/home/vcap/dump.json fixtures/dump.json

# logout from cloud foundry
unset CF_USERNAME
unset CF_PASSWORD
cf logout
