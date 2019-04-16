#!/bin/bash

source scripts/config.sh

for REPO in "${REPO_LIST[@]}"; do
    REPO_DIR=$WORKSPACE_DIR/$REPO

    echo "Running '${@:1}' for $REPO"
    ./scripts/eval.sh $REPO ${@:1}
done
