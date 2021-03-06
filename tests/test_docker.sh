#!/bin/bash

# create copy of local workspace
TEST_NAME="ultimate-docker"
mkdir -p tmp/$TEST_NAME
rsync -av --exclude='tmp' --exclude='.git' . tmp/$TEST_NAME/local-workspace

(
    cd tmp/$TEST_NAME/local-workspace
    source scripts/config.sh
    export DURATION_LOG_NAME=$TEST_NAME

    logduration make clone
    logduration ./scripts/patch.sh 1
    ./scripts/eval.sh cms ./scripts/pull_fixtures.sh

    logduration ./scripts/make_host.sh clean
    logduration make run-dbs
    logduration make create-dbs

    logduration docker-compose -f docker-compose.services.yml build
    logduration make run-docker
    logduration ./scripts/make_docker.sh migrate
    logduration ./scripts/make_docker.sh load-fixtures
    # logduration  ./scripts/make_docker.sh compile-assets
    logduration ./scripts/make_docker.sh collect-assets

    # run celery to process cold cache queue for 10 seconds
    nohup docker-compose -f docker-compose.services.yml exec cms bash -c "make -f new_makefile run-celery" &

    # make healthcheck test for all endpoints until it succeeds (100 retries)
    logduration ./tests/check_ready.sh 100
    parse_duration_log $DURATION_LOG_NAME

    # cleanup
    make clean-docker
    kill $(jobs -p)
)

sudo rm -rf tmp/$TEST_NAME
