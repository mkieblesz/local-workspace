#!/bin/bash

source scripts/config.sh

for REPO_NAME in "${REPO_LIST[@]}"; do
    REPO_DIR=$WORKSPACE_DIR/$REPO_NAME

    ./scripts/eval.sh $REPO_NAME ${@:1}
done
