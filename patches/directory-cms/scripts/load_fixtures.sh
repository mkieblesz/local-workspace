#!/bin/bash

number_of_pages=$(python manage.py shell -c "from wagtail.core.models import Page; print(Page.objects.count())" | sed '$!d')
if [ ! $number_of_pages -gt 10 ]; then
    echo "Loading fixture dump will erase all data from your cms database. Do you want to continue? [Y/n]"
    read should_continue
    if [ ! -z $should_continue ] && [ $should_continue == "n" ]; then
        exit 0
    fi
fi

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
