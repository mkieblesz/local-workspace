#!/bin/bash

source scripts/config.sh

DOCKER_SERVICES=$(for REPO_NAME in ${REPO_LIST[@]}; do get_repo_acronym $REPO_NAME; done)
docker-compose -f docker-compose.services.yml up -d $DOCKER_SERVICES
