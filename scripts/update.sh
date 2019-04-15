#!/bin/bash

source scripts/config.sh

for REPO in "${REPO_LIST[@]}"; do
    REPO_DIR=$WORKSPACE_DIR/$REPO

    echo "Updating $REPO"
    (
        cd "$REPO_DIR"
        git status
        echo "Fetching"
        git fetch
        echo "Pulling"
        git pull
    )
done
