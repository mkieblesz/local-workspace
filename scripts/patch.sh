#!/bin/bash

source scripts/config.sh

for REPO in "${REPO_LIST[@]}"; do
    REPO_DIR=$WORKSPACE_DIR/$REPO

    # if this repo is in workspace folder omit
    if [ $REPO_DIR == $WORKSPACE_REPO_DIR ]; then
        continue
    fi

    if [ -d "$REPO_DIR/.git" ]; then
        (
            cd $REPO_DIR
            REPO_PATCH_DIR=$WORKSPACE_REPO_DIR/patches/$REPO
            # apply git patch (remove after changes are merged)
            if [ -d "$REPO_PATCH_DIR/git.patch" ]; then
                git reset --hard
                git apply $REPO_PATCH_DIR/git.patch
            fi
            if [ -d "$REPO_PATCH_DIR/fixtures" ]; then
                mkdir -p fixtures
                cp $REPO_PATCH_DIR/fixtures/* fixtures
            fi
            if [ -f "$REPO_PATCH_DIR/makefile" ]; then
                cp $REPO_PATCH_DIR/makefile new_makefile
            fi
            if [ -f "$REPO_PATCH_DIR/Dockerfile" ]; then
                cp $REPO_PATCH_DIR/Dockerfile new_Dockerfile
            fi
            if [ -f "$REPO_PATCH_DIR/.env" ]; then
                cp $REPO_PATCH_DIR/.env .new_env
            fi
            if [ -f "$REPO_PATCH_DIR/.env.test" ]; then
                cp $REPO_PATCH_DIR/.env.test .new_env.test
            fi
            if [ -f "$REPO_PATCH_DIR/.env.links" ]; then
                cp $REPO_PATCH_DIR/.env.links .new_env.links
            fi

            # extra setup for exopps
            if [ "$REPO" == "export-opportunities" ]; then
                cp $REPO_PATCH_DIR/application.yml $REPO_DIR/config/application.yml
            fi
        )
    fi
done
