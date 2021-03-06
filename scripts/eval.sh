#!/bin/bash

source scripts/config.sh

REPO_NAME=$(get_repo_name $1)
EXECUTION_ORDER_LOG_FILE=$WORKSPACE_REPO_DIR/logs/$OUTPUT_ID.order_log
# text formating
CYAN=$'\033[0;36m'
YELLOW=$'\033[0;33m'
BOLD=$'\033[1m'
RESETALL=$'\033[0m'

if [ -d "$WORKSPACE_DIR/$REPO_NAME" ]; then
    (
        source scripts/activate.sh $REPO_NAME
        STDIN_HEADER="${YELLOW}$REPO_NAME\$${RESETALL} ${@:2}"
        STDIN_HEADER_REPRINT="${BOLD}[...]${RESETALL} $STDIN_HEADER"
        echo $STDIN_HEADER

        # for commands runned in parallel prepend each job output with header
        # in case previous output was from another job
        if [ ! -z $OUTPUT_ID ]; then
            logduration eval "${@:2}" |& \
                while read LINE
                do
                    # if last output was from another repo reprint header
                    if [ "$(tail -n 1 $EXECUTION_ORDER_LOG_FILE 2> /dev/null)" != $REPO_NAME ]; then
                        echo $REPO_NAME >> $EXECUTION_ORDER_LOG_FILE
                        echo $STDIN_HEADER_REPRINT
                    fi
                    echo $LINE
                done
        else
            logduration eval "${@:2}"
        fi
    )
else
    echo "$REPO_NAME repo is not present in $WORKSPACE_DIR"
fi
