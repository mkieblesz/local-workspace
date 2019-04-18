# login to cloud foundry directory-dev space
cf login
cf ssh directory-cms-dev -c "deps/0/bin/python3.6 app/manage.py dumpdata  --indent 4 > dump.json"

# scp dump back fixtures/dump.json to local by following instructions from link below
# https://docs.cloudfoundry.org/devguide/deploy-apps/ssh-apps.html#-app-ssh-access-without-cf-cli
# get single use access code and copy it to the clipboard
cf ssh-code
GUID=$(cf app directory-cms-dev --guid)
SSH_ENDPOINT=$(cf curl /v2/info | jq -r .app_ssh_endpoint | cut -f1 -d":")
VERSION=$(cf curl /v2/info | jq -r .version)
# run command below and paste single use access code from clipboard into the password prompt
scp -P 2222 -o User=cf:$GUID/$VERSION $SSH_ENDPOINT:/home/vcap/dump.py fixtures/dump.json
