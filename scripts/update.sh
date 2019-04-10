#!/bin/bash

source scripts/config.sh

# tells for loop to list items by new line
IFS=$'\n'

for REPO in `ls "$WORKSPACE_DIR/"`; do
  REPOPATH=$WORKSPACE_DIR/$REPO

  # if this repo is in workspace folder omit
  if [ $REPOPATH == $WORKSPACE_REPO_DIR ]; then
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
    )

    # patch repos
    (
      REPOPATCH=$WORKSPACE_REPO_DIR/patches/$REPO
      echo $REPOPATCH
      if [ -d "$REPOPATCH" ]; then
        echo $REPOPATCH
        if [ -d "$REPOPATCH/fixtures" ]; then
          mkdir -p $REPOPATH/fixtures
          cp $REPOPATCH/fixtures/* $REPOPATH/fixtures
        fi
        if [ -f "$REPOPATCH/makefile" ]; then
          cp $REPOPATCH/makefile $REPOPATH/new_makefile
        fi
        if [ -f "$REPOPATCH/Dockerfile" ]; then
          cp $REPOPATCH/Dockerfile $REPOPATH/new_Dockerfile
        fi
        if [ -f "$REPOPATCH/.env" ]; then
          cp $REPOPATCH/.env $REPOPATH/.new_env
        fi
        if [ -f "$REPOPATCH/.env.test" ]; then
          cp $REPOPATCH/.env.test $REPOPATH/.new_env.test
        fi
        if [ "$REPO" == "export-opportunities" ]; then
            cp $REPOPATCH/application.yml $REPOPATH/config/application.yml
            cp $REPOPATCH/database.yml $REPOPATH/config/database.yml
            cp $REPOPATCH/seeds.rb $REPOPATH/db/seeds.rb
        fi
      fi
    )
  fi
done
