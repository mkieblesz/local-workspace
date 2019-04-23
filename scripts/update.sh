#!/bin/bash

source scripts/config.sh

for REPO_NAME in "${REPO_LIST[@]}"; do
    REPO_DIR=$WORKSPACE_DIR/$REPO_NAME

    echo "Updating $REPO_NAME"
    (
        cd "$REPO_DIR"
        git status
        echo "Fetching"
        git fetch
        git stash
        echo "Pulling"
        git pull
        git stash apply
    )
done
