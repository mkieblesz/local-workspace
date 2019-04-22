#!/bin/bash

source scripts/config.sh

make clean
make remove-installs

export DURATION_LOG_NAME="ultimate-docker"
make clean-docker
./scripts/make_host.sh clean
make run-dbs
make create-dbs

docker-compose build
docker-compose up -d
./scripts/make_compose.sh migrate
./scripts/make_compose.sh load-fixtures
# ./scripts/make_compose.sh compile-assets
./scripts/make_compose.sh collect-assets

# run sanity check to put tasks on cold cache queue
./tests/sanity.sh
# run celery to process cold cache queue for 10 seconds
(docker-compose exec cms make -f new_makefile run-celery) &
CELERY_PID=$(echo $!)
sleep 10
# sanity check should be successfull here
./tests/sanity.sh

pkill -P $CELERY_PID
make clean-docker

parse_duration_log $DURATION_LOG_NAME