#!/bin/bash

source scripts/config.sh

# tells for loop to list items by new line
IFS=$'\n'
CMDS=()
for REPO in `ls "$WORKSPACE_DIR/"`; do
    REPO_DIR=$WORKSPACE_DIR/$REPO

    # only for repos for which make target exists
    if [ -f "$REPO_DIR/new_makefile" ] && grep -Fq "$1:" $REPO_DIR/new_makefile; then
        CMDS+=("./scripts/eval.sh $REPO make -f new_makefile $1")
    fi
done

# run all commands in parallel
JOBS=${#CMDS[@]}
parallel -u --jobs $JOBS ::: ${CMDS[@]}
