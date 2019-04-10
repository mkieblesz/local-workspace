#!/bin/bash

source scripts/config.sh

# tells for loop to list items by new line
IFS=$'\n'

declare -A SERVICE_MAP
SERVICE_MAP["directory-api"]="api"
SERVICE_MAP["directory-ui-buyer"]="buyer"
SERVICE_MAP["export-opportunities"]="exopps"
SERVICE_MAP["directory-sso"]="sso"
SERVICE_MAP["directory-sso-proxy"]="sso-proxy"
SERVICE_MAP["directory-ui-supplier"]="supplier"
SERVICE_MAP["directory-sso-profile"]="sso-profile"
SERVICE_MAP["great-domestic-ui"]="exred"
SERVICE_MAP["navigator"]="soo"
SERVICE_MAP["directory-cms"]="cms"
SERVICE_MAP["directory-forms-api"]="forms-api"
SERVICE_MAP["invest-ui"]="invest"
SERVICE_MAP["great-international-ui"]="international"

for REPO in `ls "$WORKSPACE_DIR/"`; do
  REPO_DIR=$WORKSPACE_DIR/$REPO
  # only for repos for which make target exists
  if [ -f "$REPO_DIR/new_makefile" ] && grep -Fq "$1:" $REPO_DIR/new_makefile; then
    docker-compose -f $WORKSPACE_REPO_DIR/docker-compose.yml exec "${SERVICE_MAP["$REPO"]}" make -f new_makefile $1
  fi
done
