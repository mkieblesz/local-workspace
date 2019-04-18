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

# get last migration
read -r -d '' LAST_MIGRATION_SCRIPT << EOM
from django.db.migrations.recorder import MigrationRecorder
last_migration = MigrationRecorder.Migration.objects.latest('id')
print(last_migration.name)
EOM
LAST_MIGRATION_NAME=$(cf ssh directory-cms-dev -c "deps/0/bin/python3.6 app/manage.py shell < <(echo \"$LAST_MIGRATION_SCRIPT\")" | sed '$!d')

# ensure database is recreated
# dropdb --if-exists directory_cms_debug; createdb --owner=debug directory_cms_debug

# run migration up to LAST_MIGRATION_NAME, if not set it will run all
make -f new_makefile migrate

# truncate all tables which were populated by migrations
# update sqlflush sql to truncate in cascade mode
SQLFLUSH=$(python manage.py sqlflush | sed -e '2 s/;/ CASCADE;/g')
read -r -d '' FLUSH_SCRIPT << EOM
from django.db import connection, transaction
with transaction.atomic(savepoint=connection.features.can_rollback_ddl):
    with connection.cursor() as cursor:
        cursor.execute('''$SQLFLUSH''')
EOM
python manage.py shell < <(echo "$FLUSH_SCRIPT")

# finally load data
# load data with monkey patched signals
read -r -d '' LOAD_DATA_SCRIPT << EOM
from unittest import mock
from django.core.management.commands.loaddata import Command as LoadDataCommand
from django.db import DEFAULT_DB_ALIAS
cmd = LoadDataCommand()
opts = {
    'ignore': False,
    'database': DEFAULT_DB_ALIAS,
    'app_label': None,
    'verbosity': 1,
    'exclude': []
}

# monkey patch django signals
from django.dispatch.dispatcher import Signal

def send(*args, **kwargs):
    pass
def send_robust(*args, **kwargs):
    pass
Signal.send = send
Signal.send_robust = send_robust
cmd.handle('fixtures/dump.json', **opts)
EOM
python manage.py shell < <(echo "$LOAD_DATA_SCRIPT")

# run remaining migrations which were not present in cf dev environment
unset LAST_MIGRATION_NAME
make -f new_makefile migrate
