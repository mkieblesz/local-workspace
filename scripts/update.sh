#!/bin/bash

source scripts/config.sh

# tells for loop to list items by new line
IFS=$'\n'

for REPO in `ls "$WORKSPACE_DIR/"`; do
  REPOPATH=$WORKSPACE_DIR/$REPO

  # if this repo is in workspace folder omit
  if [ $REPOPATH == $(pwd) ]; then
    continue
  fi

  if [ -d "$REPOPATH/.git" ]; then
    echo "Updating $REPO"
    (
      cd "$REPOPATH"
      git status
      echo "Fetching"
      git fetch
      echo "Pulling"
      git pull

      # TODO: move to makefiles
      if [ -f "$REPOPATH/requirements_test.txt" ]; then
        if [ ! -d "$REPOPATH/.venv" ]; then
          echo "Initializing python virtual environment in $REPOPATH/.venv folder"
          python3 -m venv .venv
          .venv/bin/pip install --upgrade pip wheel
        fi
        echo "Updating pip packages"
        .venv/bin/pip install -r requirements_test.txt
      fi

      if [ -f "$REPOPATH/Gemfile" ]; then
        (
          cd $REPOPATH
          echo "Updating gems"
          bundle _1.16.6_ install
        )
      fi

      # if [ -f "$REPOPATH/package.json" ]; then
      #   echo "Updating npm packages"
      #   (
      #     cd $REPOPATH
      #     npm install
      #   )
      # fi

      # patch export opportunities separately
      if [ "$REPO" == "export-opportunities" ]; then
          cp $(pwd)/services/$REPO/application.yml $REPOPATH/config/application.yml
          cp $(pwd)/services/$REPO/database.yml $REPOPATH/config/database.yml
          cp $(pwd)/services/$REPO/seeds.rb $REPOPATH/db/seeds.rb
      fi
    )
  fi
done
