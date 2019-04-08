#!/bin/bash

# tells for loop to list items by new line
IFS=$'\n'

for SERVICE in `ls "services/"`; do
  # only for services for which make target exists
  if [ -f "services/$SERVICE/makefile" ] && grep -Fq "$1:" services/$SERVICE/makefile; then
    echo "Running \"make $1\" for $SERVICE"
    REPO=$WORKSPACE_DIR/$SERVICE
    REPO_PATCH=services/$SERVICE
    (
      cd $REPO_PATCH
      test -d $REPO/.venv && source $REPO/.venv/bin/activate
      set -o allexport
      test -f $REPO_PATCH/.env && source $REPO_PATCH/.env
      make $1
      set +o allexport
    )
  else
    echo "Target $1 doesn't exist in services/$SERVICE/makefile"
  fi
done
