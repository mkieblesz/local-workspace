#!/bin/bash

source scripts/config.sh

for REPO in "${REPO_LIST[@]}"; do
    REPO_DIR=$WORKSPACE_DIR/$REPO

    echo "Running 'make $1' for $REPO"

    # only for repos for which make target exists
    if [ -f "$REPO_DIR/new_makefile" ] && grep -Fq "$1:" $REPO_DIR/new_makefile; then
        docker-compose -f $WORKSPACE_REPO_DIR/docker-compose.yml exec "$(get_repo_acronym $REPO)" make -f new_makefile $1
    fi
done
