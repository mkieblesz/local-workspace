#!/bin/bash

# create copy of local workspace
TEST_NAME="ultimate"
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

    logduration make create-venvs
    logduration ./scripts/make_host.sh install
    logduration ./scripts/make_host.sh migrate
    logduration ./scripts/make_host.sh load-fixtures
    # logduration ./scripts/make_host.sh compile-assets
    logduration ./scripts/make_host.sh collect-assets

    # no point of logging duration of running processes
    nohup make run-all &
    # run celery to process cold cache queue for 10 seconds
    (nohup ./scripts/eval.sh cms make -f new_makefile run-celery) &

    # make healthcheck for all endpoints until it succeeds
    logduration ./tests/healthcheck.sh 100
    parse_duration_log $DURATION_LOG_NAME

    # cleanup
    kill $(jobs -p)
    make clean-docker
)

sudo rm -rf tmp/$TEST_NAME
