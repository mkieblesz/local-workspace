#!/bin/bash

source scripts/config.sh

deactivate_env () {
    cdworkrepo
    deactivate_repo
    unset -f cdworkrepo
    unset -f work
    unset -f deactivate_env
    # scripts/config.sh
    unset -f get_repo_acronym
    unset -f get_repo_name
    unset REPO_ACRONYM_MAP
    unset VERSION_MAP
    unset REPO_LIST
    unset WORKSPACE_REPO_DIR
    unset WORKSPACE_DIR
}

cdworkrepo () {
    cd $WORKSPACE_REPO_DIR
}

work () {
    deactivate_repo nondestructive
    cdrepo () {
        cd $REPO_DIR
    }
    export REPO=$(get_repo_name $1)
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
    work $(get_repo_name $1)
fi
