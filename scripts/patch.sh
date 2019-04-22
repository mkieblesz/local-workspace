#!/bin/bash

source scripts/config.sh

if [ -z $1 ]; then
    echo "Patching repos will reset all your local changes."
    echo "Do you want to continue? [Y/n]"
    read should_continue
    if [ ! -z $should_continue ] && [ $should_continue == "n" ]; then
        exit 0
    fi
fi

for REPO_NAME in "${REPO_LIST[@]}"; do
    REPO_DIR=$WORKSPACE_DIR/$REPO_NAME

    echo "Patching $REPO_NAME"
    (
        cd $REPO_DIR
        REPO_PATCH_DIR=$WORKSPACE_REPO_DIR/patches/$REPO_NAME
        # apply git patch (remove after changes are merged)
        if [ -f "$REPO_PATCH_DIR/git.patch" ]; then
            git reset --hard
            git apply $REPO_PATCH_DIR/git.patch
        fi
        if [ -d "$REPO_PATCH_DIR/fixtures" ]; then
            mkdir -p fixtures
            cp $REPO_PATCH_DIR/fixtures/* fixtures
        fi
        if [ -d "$REPO_PATCH_DIR/scripts" ]; then
            mkdir -p scripts
            cp $REPO_PATCH_DIR/scripts/* scripts
        fi
        if [ -f "$REPO_PATCH_DIR/makefile" ]; then
            cp $REPO_PATCH_DIR/makefile new_makefile
        fi
        if [ -f "$REPO_PATCH_DIR/setup.cfg" ]; then
            cp $REPO_PATCH_DIR/setup.cfg new_setup.cfg
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
    )
done
