#!/bin/bash

source scripts/config.sh

for REPO in "${REPO_LIST[@]}"; do
    REPOPATH=$WORKSPACE_DIR/$REPO

    if [ ! -d "$REPOPATH" ]; then
        echo "Cloning $REPO"
        echo
        (
            cd $WORKSPACE_DIR
            VERSION=${VERSION_MAP[$REPO]}
            if [ ! -z $VERSION ]; then
                git clone git@github.com:uktrade/$REPO.git@$VERSION
            else
                git clone git@github.com:uktrade/$REPO.git
            fi
        )
        echo

        echo "Done"
    else
        echo "Skipping $REPO because it already exists."
    fi
    echo
done
