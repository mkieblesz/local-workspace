#!/bin/bash

source config.sh

# tells for loop to list items by new line
IFS=$'\n'

for SERVICE in `ls "services/"`; do
  # only for services for which make target exists
  if [ -f "services/$SERVICE/makefile" ] && grep -Fq "$1:" services/$SERVICE/makefile; then
    echo "Running \"make $1\" for $SERVICE"
    REPO=$WORKSPACE_DIR/$SERVICE
    REPO_PATCH=$(pwd)/services/$SERVICE
    (
      test -d $REPO/.venv && source $REPO/.venv/bin/activate
      test -f $REPO_PATCH/.env && set -o allexport; source $REPO_PATCH/.env; set +o allexport
      cd $REPO_PATCH; REPO=$REPO make $1
    )
  else
    echo "Target $1 doesn't exist in services/$SERVICE/makefile"
  fi
done
