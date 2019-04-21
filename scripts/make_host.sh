#!/bin/bash

source scripts/config.sh

for REPO_NAME in "${REPO_LIST[@]}"; do
    REPO_DIR=$WORKSPACE_DIR/$REPO_NAME

    # only for repos for which make target exists
    if [ -f "$REPO_DIR/new_makefile" ] && grep -Fq "$1:" $REPO_DIR/new_makefile; then
        ./scripts/eval.sh $REPO_NAME make -f new_makefile $1
    fi
done
