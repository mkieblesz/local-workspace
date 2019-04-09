#!/bin/bash

source scripts/config.sh
export WORKSPACE_REPO=$(pwd)

# deactivate entire env (with workspace repo)
deactivate_env () {
  cdworkrepo

  unset WORKSPACE_REPO

  if [ "$(type -t deactivate_repo)" == "function" ]; then
    deactivate_repo
    unset -f deactivate_repo
  fi
  unset -f cdworkrepo
  unset -f deactivate_env
}

# deactivate repo env
deactivate_repo () {
  unset REPO
  unset REPO_PATH
  # https://unix.stackexchange.com/a/508367
  test -f $REPO_PATCH/.env && while read var; do unset $var; done < <(cat $REPO_PATCH/.env | sed 's/=.*//g')
  unset REPO_PATCH

  # deactivate if has venv
  if [ "$(type -t deactivate)" == "function" ]; then
    deactivate
  fi

  unset -f cdrepo
}

cdworkrepo () {
  cd $WORKSPACE_REPO
}

# change repo you working on
work () {
  if [ "$(type -t deactivate_repo)" == "function" ]; then
    deactivate_repo
  fi

  cdrepo () {
    cd $REPO_PATH
  }

  export REPO=$1
  export REPO_PATH=$WORKSPACE_DIR/$REPO
  export REPO_PATCH=$WORKSPACE_REPO/services/$REPO

  # activate venv for repo if exists
  test -d $REPO_PATH/.venv && source $REPO_PATH/.venv/bin/activate
  # export environment variables if exist
  test -f $REPO_PATCH/.env && set -o allexport; source $REPO_PATCH/.env; set +o allexport

  cdrepo
}

# if argument passed that means also working on repo
if [ ! -z "$1" ]; then
  work $1
fi
