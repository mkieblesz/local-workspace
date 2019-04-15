#!/bin/bash

source scripts/config.sh

for REPO in "${REPO_LIST[@]}"; do
    REPO_DIR=$WORKSPACE_DIR/$REPO

    echo "Running '${@:1}' for $REPO"
    (
        cd $REPO_DIR
        eval "${@:1}"
    )
done
