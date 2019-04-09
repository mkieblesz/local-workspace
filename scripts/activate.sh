#!/bin/bash

source scripts/config.sh

# deactivate entire env (with workspace repo)
deactivate_env () {
  cdworkrepo
  deactivate_repo

  unset WORKSPACE_REPO_DIR
  unset -f cdworkrepo
  unset -f deactivate_env
  unset -f work
}

cdworkrepo () {
  cd $WORKSPACE_REPO_DIR
}

# change repo you working on
work () {
  deactivate_repo nondestructive

  cdrepo () {
    cd $REPO_DIR
  }

  export REPO=$1
  export REPO_DIR=$WORKSPACE_DIR/$REPO
  export REPO_PATCH=$WORKSPACE_REPO_DIR/services/$REPO

  # alias to patched make
  alias pmake="make -f $WORKSPACE_REPO_DIR/services/$REPO/makefile"

  # activate venv for repo
  if [ -d $REPO_DIR/.venv ]; then
    source $REPO_DIR/.venv/bin/activate
  fi

  # export environment variables
  if [ -d $REPO_DIR/.venv ]; then
    set -o allexport
    source $REPO_PATCH/.env
    set +o allexport
  fi

  cdrepo
}

# deactivate repo env
deactivate_repo () {
  unset REPO
  unset REPO_DIR
  # https://unix.stackexchange.com/a/508367
  test -f $REPO_PATCH/.env && while read var; do unset $var; done < <(cat $REPO_PATCH/.env | sed 's/=.*//g')
  unset REPO_PATCH

  # deactivate if has venv
  if [ "$(type -t deactivate)" == "function" ]; then
    deactivate
  fi

  unset -f cdrepo

  if [ ! "$1" = "nondestructive" ] ; then
  # Self destruct!
    unset -f deactivate_repo
    unalias pmake
  fi
}

# if argument passed that means also working on repo
if [ ! -z "$1" ]; then
  work $1
fi
