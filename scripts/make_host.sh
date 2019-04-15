#!/bin/bash

source scripts/config.sh

for REPO in "${REPO_LIST[@]}"; do
    REPO_DIR=$WORKSPACE_DIR/$REPO

    echo "Running 'make $1' for $REPO"

    # only for repos for which make target exists
    if [ -f "$REPO_DIR/new_makefile" ] && grep -Fq "$1:" $REPO_DIR/new_makefile; then
        ./scripts/eval.sh $REPO make -f new_makefile $1
    fi
done
