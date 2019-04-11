#!/bin/bash

source scripts/config.sh

REPO_NAME=$(get_repo_name $1)

if [ -d "$WORKSPACE_DIR/$REPO_NAME" ]; then
    (
        source scripts/activate.sh $REPO_NAME
        eval "${@:2}"
    )
else
    echo "Repo not found"
fi
