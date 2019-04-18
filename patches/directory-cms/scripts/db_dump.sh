# login to cloud foundry directory-dev space
cf login
# create database dump in cf cms host
cf ssh directory-cms-dev -c "deps/0/bin/python3.6 app/manage.py dumpdata  --indent 4 > dump.json"

# use django-extensions dumpscript to create fixtures as python script
read -r -d '' PYTHON_SCRIPT << EOM
from collections import OrderedDict
from django.apps import apps
from django.conf import settings
from django.core import management

settings.INSTALLED_APPS += ('django_extensions', )
apps.app_configs = OrderedDict()
apps.ready = False
apps.populate(settings.INSTALLED_APPS)

all_model_list=[]
for app_key, model_list in apps.all_models.items():
    if model_list:
        for model_key, Model in model_list.items():
            all_model_list.append('{}.{}'.format(app_key, model_key))
            # print('{}.{}'.format(app_key, model_key))

from django_extensions.management.commands import dumpscript
dumpscript.Command().handle(skip_autofield=True, appname=all_model_list)
EOM
# install django extensions to dump fixtures as python script
deps/0/bin/python3.6 -m pip install django-extensions
deps/0/bin/python3.6 app/manage.py shell < <(echo "$PYTHON_SCRIPT") > dump.py

# scp dump back fixtures/dump.json to local by following instructions from link below
# https://docs.cloudfoundry.org/devguide/deploy-apps/ssh-apps.html#-app-ssh-access-without-cf-cli
# get single use access code and copy it to the clipboard
cf ssh-code
GUID=$(cf app directory-cms-dev --guid)
SSH_ENDPOINT=$(cf curl /v2/info | jq -r .app_ssh_endpoint | cut -f1 -d":")
VERSION=$(cf curl /v2/info | jq -r .version)
# run command below and paste single use access code from clipboard into the password prompt
scp -P 2222 -o User=cf:$GUID/$VERSION $SSH_ENDPOINT:/home/vcap/dump.py dump.py
