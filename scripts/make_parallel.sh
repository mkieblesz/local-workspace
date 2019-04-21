#!/bin/bash

source scripts/config.sh

OUTPUT_ID=$BASHPID

CMDS=()
for REPO_NAME in "${REPO_LIST[@]}"; do
    REPO_DIR=$WORKSPACE_DIR/$REPO_NAME

    # only for repos for which make target exists
    if [ -f "$REPO_DIR/new_makefile" ] && grep -Fq "$1:" $REPO_DIR/new_makefile; then
        CMDS+=("OUTPUT_ID=$OUTPUT_ID ./scripts/eval.sh $REPO_NAME make -f new_makefile $1")
    fi
done

JOBS=${#CMDS[@]}
parallel --linebuffer --jobs $JOBS ::: ${CMDS[@]}
