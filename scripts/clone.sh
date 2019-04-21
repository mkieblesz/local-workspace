#!/bin/bash

source scripts/config.sh

for REPO_NAME in "${REPO_LIST[@]}"; do
    REPO_DIR=$WORKSPACE_DIR/$REPO_NAME

    if [ ! -d "$REPO_DIR" ]; then
        echo "Cloning $REPO_NAME"
        echo
        (
            cd $WORKSPACE_DIR
            VERSION=${VERSION_MAP[$REPO_NAME]}
            if [ ! -z $VERSION ]; then
                git clone git@github.com:uktrade/$REPO_NAME.git@$VERSION
            else
                git clone git@github.com:uktrade/$REPO_NAME.git
            fi
        )
        echo

        echo "Done"
    else
        echo "Skipping $REPO_NAME because it already exists."
    fi
    echo
done
