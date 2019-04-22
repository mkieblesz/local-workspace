#!/bin/bash

# create copy of local workspace
TEST_NAME="ultimate-docker"
mkdir -p tmp/$TEST_NAME
rsync -av --exclude='tmp' --exclude='.git' . tmp/$TEST_NAME/local-workspace

(
    cd tmp/$TEST_NAME-docker/local-workspace
    source scripts/config.sh
    export DURATION_LOG_NAME=$TEST_NAME

    logduration make clone
    logduration ./scripts/patch.sh 1
    ./scripts/eval.sh cms ./scripts/pull_fixtures.sh

    logduration ./scripts/make_host.sh clean
    logduration make run-dbs
    logduration make create-dbs

    logduration docker-compose build
    logduration docker-compose up -d
    logduration ./scripts/make_compose.sh migrate
    logduration ./scripts/make_compose.sh load-fixtures
    # logduration  ./scripts/make_compose.sh compile-assets
    logduration ./scripts/make_compose.sh collect-assets

    # run sanity check to put tasks on cold cache queue
    logduration WAIT_UNTIL_OK=true ./tests/sanity.sh
    # run celery to process cold cache queue for 10 seconds
    nohup docker-compose exec cms bash -c "make -f new_makefile run-celery" &

    # make sanity test for all endpoints until it succeeds
    logduration ./tests/sanity.sh 100
    parse_duration_log $DURATION_LOG_NAME

    # cleanup
    make clean-docker
    kill $(jobs -p)
)

sudo rm -rf tmp/$TEST_NAME
