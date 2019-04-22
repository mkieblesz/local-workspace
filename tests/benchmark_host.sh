#!/bin/bash

source scripts/config.sh

make clean
make remove-installs

export DURATION_LOG_NAME="ultimate"
make clean-docker
./scripts/make_host.sh clean
make run-dbs
make create-dbs

make create-venvs
./scripts/make_host.sh install
./scripts/make_host.sh migrate
./scripts/make_host.sh load-fixtures
# ./scripts/make_host.sh compile-assets
./scripts/make_host.sh collect-assets

make run-all &
RUN_ALL_PID=$(echo $!)
sleep 10

# run sanity check to put tasks on cold cache queue
./tests/sanity.sh
# run celery to process cold cache queue for 10 seconds
(./scripts/eval.sh cms make -f new_makefile run-celery) &
CELERY_PID=$(echo $!)
sleep 10

# sanity check should be successfull here
./tests/sanity.sh

pkill -P $RUN_ALL_PID $CELERY_PID

parse_duration_log $DURATION_LOG_NAME
