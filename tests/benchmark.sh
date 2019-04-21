#!/bin/bash

source scripts/config.sh

ultimate() {
    export DURATION_LOG_NAME="ultimate"
    logduration docker-compose down
    logduration make fix-permissions
    logduration ./scripts/make_host.sh clean
    logduration make run-dbs
    logduration make create-dbs
    ./scripts/make_host.sh migrate
    ./scripts/make_host.sh load-fixtures
    ./scripts/make_host.sh compile-assets
    ./scripts/make_host.sh collect-assets
    make run-all &
    ./scripts/sanity.sh
    parse_duration_log $DURATION_LOG_NAME
}

ultimate-docker() {
    export DURATION_LOG_NAME="ultimate-docker"
    logduration docker-compose down
    logduration ./scripts/make_host.sh clean
    ./scripts/make_host.sh build
    logduration make run-dbs
    logduration make create-dbs
    logduration docker-compose up -d
    ./scripts/make_compose.sh migrate
    ./scripts/make_compose.sh load-fixtures
    ./scripts/make_compose.sh compile-assets
    ./scripts/make_compose.sh collect-assets
    ./scripts/sanity.sh
    parse_duration_log $DURATION_LOG_NAME
}

# run dbs in docker and services on host
ultimate
# run all in docker
ultimate-docker
# rerun dbs in docker and services on host
ultimate