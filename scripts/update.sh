#!/bin/bash

source config.sh

# tells for loop to list items by new line
IFS=$'\n'

for REPO in `ls "$WORKSPACE_FOLDER/"`
do
  REPOPATH=$WORKSPACE_FOLDER/$REPO

  # if this repo is in workspace folder omit
  if [ $REPOPATH == $(pwd) ]; then
    continue
  fi

  if [ -d "$REPOPATH" ]; then
    echo "Updating $REPO"
    echo
    if [ -d "$REPOPATH/.git" ]
    then
      (
        cd "$REPOPATH"
        git status
        echo "Fetching"
        git fetch
        echo "Pulling"
        git pull
        echo "Updating requirements"
        .venv/bin/pip install -r requirements_test.txt
      )
      echo "Done"
    else
      echo "Skipping because it doesn't look like it has a .git folder."
    fi
    echo
  fi
done
