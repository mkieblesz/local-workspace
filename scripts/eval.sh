#!/bin/bash

source scripts/config.sh

REPO_NAME=$(get_repo_name $1)

if [ -d "$WORKSPACE_DIR/$REPO_NAME" ]; then
    (
        echo
        echo "Running '${@:2}' in $REPO_NAME repo"
        source scripts/activate.sh $REPO_NAME

        # pretty prefix of command output
        CYAN=$'\033[0;36m'
        BOLD=$'\033[1m'
        RESETALL=$'\033[0m'
        PREFIX="${CYAN}${BOLD}$REPO_NAME$ ${RESETALL}"
        PADDING='                                         '
        PREFIX=$(printf "%s %s" $PREFIX "${PADDING:${#PREFIX}}")
        # |& pipes stdout and stderr
        eval "${@:2}" |& sed -u "s/^/$PREFIX/"

        # stdbuf prints immediatelly, equivalent of sed -u https://unix.stackexchange.com/a/248926
        # eval "${@:2}" |& stdbuf -oL awk -v p=$PREFIX '{print p,$0}'
    )
else
    echo "Repo not found"
fi
