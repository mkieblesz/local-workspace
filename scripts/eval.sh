#!/bin/bash

source scripts/config.sh

REPO_NAME=$(get_repo_name $1)

# text formating
CYAN=$'\033[0;36m'
YELLOW=$'\033[0;33m'
BOLD=$'\033[1m'
RESETALL=$'\033[0m'

if [ -d "$WORKSPACE_DIR/$REPO_NAME" ]; then
    (
        source scripts/activate.sh $REPO_NAME

        STDIN_PREFIX="${YELLOW}$REPO_NAME\$${RESETALL}"
        echo "$STDIN_PREFIX ${@:2}"

        # for commands runned in parallel prepend each job continous output with header
        if [ ! -z $OUTPUT_ID ]; then
            EXECUTION_ORDER_LOG=$WORKSPACE_REPO_DIR/logs/$OUTPUT_ID.order_log
            eval "${@:2}" |& \
                while read LINE
                do
                    test ! -f $EXECUTION_ORDER_LOG && touch $EXECUTION_ORDER_LOG
                    # if last output was from another repo reprint stdin header
                    if [ "$(tail -n 1 $EXECUTION_ORDER_LOG)" != $REPO_NAME ]; then
                        echo "${BOLD}[...]${RESETALL} $STDIN_PREFIX ${@:2}"
                        echo $REPO_NAME >> $EXECUTION_ORDER_LOG
                    fi
                    echo "$LINE"
                done
        else
            # |& pipes stdout and stderr
            eval "${@:2}"
        fi

        # stdbuf prints immediatelly, equivalent of sed -u https://unix.stackexchange.com/a/248926
        # eval "${@:2}" |& stdbuf -oL awk -v p=$PREFIX '{print p,$0}'
    )
else
    echo "Repo not found"
fi
