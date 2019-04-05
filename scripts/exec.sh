#!/bin/bash

source config.sh

cd $WORKSPACE_FOLDER/${REPO}
source .venv/bin/activate
source envs/.env.${REPO}

exec "$@"
