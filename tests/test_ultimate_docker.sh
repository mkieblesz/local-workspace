#!/bin/bash

source scripts/config.sh

export DURATION_LOG_NAME="ultimate-docker"
logduration docker-compose down
logduration ./scripts/make_host.sh clean
logduration docker-compose build
logduration make run-dbs
logduration make create-dbs
logduration docker-compose up -d
./scripts/make_compose.sh migrate
./scripts/make_compose.sh load-fixtures
./scripts/make_compose.sh compile-assets
./scripts/make_compose.sh collect-assets

parse_duration_log
