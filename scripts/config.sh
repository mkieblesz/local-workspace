# variables used across scripts/*
WORKSPACE_DIR=${WORKSPACE_DIR:-$(dirname $(pwd))}
WORKSPACE_REPO_DIR=$(pwd)
REPO_LIST=()
declare -A VERSION_MAP
declare -A REPO_ACRONYM_MAP=(
    [directory-api]=api
    [directory-ui-buyer]=buyer
    [export-opportunities]=exopps
    [directory-sso]=sso
    [directory-sso-proxy]=sso-proxy
    [directory-ui-supplier]=supplier
    [directory-sso-profile]=sso-profile
    [great-domestic-ui]=exred
    [navigator]=soo
    [directory-cms]=cms
    [directory-forms-api]=forms-api
    [invest-ui]=invest
    [great-international-ui]=international
)

# populate REPO_LIST and VERSION_MAP from repolist file
IFS=$'\n'  # split into array by new line character
for REPO_DEFINITION in `cat repolist`; do
    # omit if line empty or
    # starts with hash/comment character https://serverfault.com/a/252406
    if [ -z $REPO_DEFINITION ] || [ "${REPO_DEFINITION#\#}"x != "${REPO_DEFINITION}x" ]; then
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
