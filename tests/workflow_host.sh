#!/bin/bash

source scripts/config.sh

export DURATION_LOG_NAME="ultimate"
logduration docker-compose down
logduration ./scripts/make_host.sh clean
logduration make run-dbs
logduration make create-dbs
./scripts/make_host.sh migrate
./scripts/make_host.sh load-fixtures
./scripts/make_host.sh compile-assets
./scripts/make_host.sh collect-assets

parse_duration_log
