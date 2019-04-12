#!/bin/bash

source scripts/config.sh

for REPO in "${REPO_LIST[@]}"; do
    REPO_DIR=$WORKSPACE_DIR/$REPO

    # if this repo is in workspace folder omit
    if [ $REPO_DIR == $WORKSPACE_REPO_DIR ]; then
        continue
    fi

    if [ -d "$REPO_DIR/.git" ]; then
        echo "Updating $REPO"
        (
            cd "$REPO_DIR"
            git status
            echo "Fetching"
            git fetch
            echo "Pulling"
            git pull

            # TODO: move to makefiles
            if [ -f "$REPO_DIR/requirements_test.txt" ]; then
                if [ ! -d "$REPO_DIR/.venv" ]; then
                    echo "Initializing python virtual environment in $REPO_DIR/.venv folder"
                    python3 -m venv .venv
                    .venv/bin/pip install --upgrade pip wheel
                fi
                echo "Updating pip packages"
                .venv/bin/pip install -r requirements_test.txt
            fi

            if [ -f "$REPO_DIR/Gemfile" ]; then
                (
                    cd $REPO_DIR
                    echo "Updating gems"
                    bundle _1.16.6_ install
                    # extra for exopps
                    if [ ! -f config/application.yml ]; then
                        cp config/application.example.yml config/application.yml
                    fi
                )
            fi

            # if [ -f "$REPO_DIR/package.json" ]; then
            #     echo "Updating npm packages"
            #     (
            #         cd $REPO_DIR
            #         npm install
            #     )
            # fi
        )
    fi
done
