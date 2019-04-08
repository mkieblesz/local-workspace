#!/bin/bash

source config.sh

# tells for loop to list items by new line
IFS=$'\n'

for REPO in `ls "$WORKSPACE_DIR/"`; do
  REPOPATH=$WORKSPACE_DIR/$REPO

  # if this repo is in workspace folder omit
  if [ $REPOPATH == $(pwd) ]; then
    continue
  fi

  if [ -d "$REPOPATH" ]; then
    echo "Updating $REPO"
    echo

    if [ -d "$REPOPATH/.git" ]; then
      (
        cd "$REPOPATH"
        git status
        echo "Fetching"
        git fetch
        echo "Pulling"
        git pull

        if [ -f "$REPOPATH/requirements_test.txt" ]; then
          if [ ! -d "$REPOPATH/.venv" ]; then
            echo "Initializing python virtual environment in $REPOPATH/.venv folder"
            python3 -m venv .venv
            .venv/bin/pip install --upgrade pip wheel
          fi
          echo "Updating pip packages"
          .venv/bin/pip install -r requirements_test.txt
        elif [ -f "$REPOPATH/Gemfile" ]; then
          (
            cd $REPOPATH
            echo "Updating gems"
            bundle _1.16.6_ install
          )
        fi

        if [ -f "$REPOPATH/package.json" ]; then
          echo "Updating npm packages"
          (
            cd $REPOPATH
            npm install
          )
        fi
      )
      echo "Done"
    else
      echo "Skipping because it doesn't look like it has a .git folder."
    fi
    echo
  fi
done
