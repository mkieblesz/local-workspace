#!/bin/bash

source scripts/config.sh

for REPO in $REPO_LIST; do
    REPOPATH=$WORKSPACE_DIR/$REPO

    # if this repo is in workspace folder omit
    if [ $REPOPATH == $WORKSPACE_REPO_DIR ]; then
        continue
    fi

    if [ -d "$REPOPATH/.git" ]; then
        (
            REPOPATCH=$WORKSPACE_REPO_DIR/patches/$REPO
            if [ -d "$REPOPATCH" ]; then
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
