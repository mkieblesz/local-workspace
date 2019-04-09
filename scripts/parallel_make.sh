#!/bin/bash

source scripts/config.sh

# tells for loop to list items by new line
IFS=$'\n'
CMDS=()
for SERVICE in `ls "services/"`; do
  PATCH_PATH=$WORKSPACE_REPO_DIR/services/$SERVICE
  # only for services for which make target exists
  if [ -f "$PATCH_PATH/makefile" ] && grep -Fq "$1:" $PATCH_PATH/makefile; then
    # <repo> make -f <patched makefile> <target>
    CMDS+=("./scripts/eval.sh $SERVICE make -f $PATCH_PATH/makefile $1")
  fi
done

# run all commands in parallel
JOBS=${#CMDS[@]}
parallel --jobs $JOBS ::: ${CMDS[@]}
