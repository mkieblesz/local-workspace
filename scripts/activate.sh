#!/bin/bash

source scripts/config.sh

deactivate_env () {
    cdworkrepo
    deactivate_repo
    unset -f cdworkrepo
    unset -f work
    unset -f deactivate_env
    unset WORKSPACE_REPO_DIR
}

cdworkrepo () {
    cd $WORKSPACE_REPO_DIR
}

work () {
    deactivate_repo nondestructive
    cdrepo () {
        cd $REPO_DIR
    }
    export REPO=$1
    export REPO_DIR=$WORKSPACE_DIR/$REPO

    if [ -d $REPO_DIR/.venv ]; then
        source $REPO_DIR/.venv/bin/activate
    fi
    if [ -f $REPO_DIR/.new_env ]; then
        set -o allexport
        source $REPO_DIR/.new_env
        set +o allexport
    fi
    cdrepo
}

deactivate_repo () {
    # https://unix.stackexchange.com/a/508367
    if [ -f $REPO_DIR/.new_env ]; then
        while read var; do unset $var; done < <(cat $REPO_DIR/.new_env | sed 's/=.*//g')
    fi
    # deactivate if has venv
    if [ "$(type -t deactivate)" == "function" ]; then
        deactivate
    fi
    unset REPO_DIR
    unset REPO
    unset -f cdrepo
    if [ ! "$1" = "nondestructive" ] ; then
        unset -f deactivate_repo
    fi
}

if [ ! -z "$1" ]; then
    work $1
fi
