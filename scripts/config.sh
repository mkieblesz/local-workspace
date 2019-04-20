mkdir -p tmp logs

# variables used across scripts/*
WORKSPACE_DIR=$(dirname $(pwd))
WORKSPACE_NAME=$(basename $WORKSPACE_DIR)
WORKSPACE_REPO_DIR=$(pwd)
REPO_LIST=()
declare -A VERSION_MAP
declare -A REPO_ACRONYM_MAP=(
    [directory-api]=api
    [directory-ui-buyer]=buyer
    [export-opportunities]=exopps
    [directory-sso]=sso
    [directory-sso-proxy]=ssoproxy
    [directory-ui-supplier]=supplier
    [directory-sso-profile]=profile
    [great-domestic-ui]=domestic
    [navigator]=soo
    [directory-cms]=cms
    [directory-forms-api]=formsapi
    [invest-ui]=invest
    [great-international-ui]=international
)

# populate REPO_LIST and VERSION_MAP from repolist file
IFS=$'\n'  # split into array by new line character
for REPO_DEFINITION in `cat repolist`; do
    FIRST_CHAR=$(echo $REPO_DEFINITION | head -c 1)
    # omit if line empty or starts with hash
    if [ -z $FIRST_CHAR ] || [ $FIRST_CHAR = "#" ]; then
        continue
    fi
    # split by @
    IFS=@ read -r REPO VERSION <<< "$REPO_DEFINITION"
    if [ ! -z $VERSION ]; then
        VERSION_MAP[$REPO]=$VERSION
    fi
    REPO_LIST+=($REPO)
done

get_repo_acronym() {
    if [ ${REPO_ACRONYM_MAP[$1]} ]; then
        echo ${REPO_ACRONYM_MAP[$1]}
    fi
}

# accepts repo full name or acronym and returns repo name
get_repo_name() {
    REPO_NAME=
    for REPO_NAME_FOR_ACRONYM in "${!REPO_ACRONYM_MAP[@]}"
    do
        if [ ${REPO_ACRONYM_MAP[$REPO_NAME_FOR_ACRONYM]} == $1 ]; then
            REPO_NAME=$REPO_NAME_FOR_ACRONYM
            break
        fi
    done

    # if repo name wasn't set assume full name was passed
    if [ -z $REPO_NAME ]; then
        REPO_NAME=$1
    fi
    echo $REPO_NAME
}

logduration() {
    DURATION_LOG_NAME=${DURATION_LOG_NAME:-"common"}
    DURATION_LOG_FILE=$WORKSPACE_REPO_DIR/logs/$DURATION_LOG_NAME.duration_log
    START_TIME=$(date +%s)
    LOG_ENTRY_NAME=$(basename $(pwd))
    ${@:1}
    # create timing log entry only if duration longer than 3 seconds
    DURATION=$(($(date +%s) - $START_TIME))
    if (($DURATION > 1)); then
        echo "$DURATION:$LOG_ENTRY_NAME:${@:1}" >> $DURATION_LOG_FILE
    fi
}

displaytime() {
    local T=$1
    local H=$((T/60/60))
    local M=$((T/60%60))
    local S=$((T%60))
    (( $H > 0 )) && printf '%d hours ' $H
    (( $M > 0 )) && printf '%d minutes ' $M
    (( $S > 0 )) && printf '%d seconds' $S
}

parse_duration_log() {
    DURATION_LOG_NAME=${DURATION_LOG_NAME:-"common"}
    DURATION_LOG_FILE=$WORKSPACE_REPO_DIR/logs/$DURATION_LOG_NAME.duration_log
    IFS=$'\n'  # split into array by new line character
    for LOG_ENTRY in `cat $DURATION_LOG_FILE`; do
        echo $LOG_ENTRY
    done
}