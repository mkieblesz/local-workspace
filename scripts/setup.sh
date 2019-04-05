#!/bin/bash

source config.sh
IFS=$'\n'

for REPO in `cat repolist`
do
  # if empty line move on
  if [ -z "$REPO" ]; then
    continue
  fi

  REPOPATH=$WORKSPACE_FOLDER/$REPO

  if [ ! -d "$REPOPATH" ]; then
    # clone repository
    echo "Setting up $REPO"
    echo
    (
      cd $WORKSPACE_FOLDER
      git clone git@github.com:uktrade/$REPO.git
    )
    echo

    # if it's python package setup virtualenv and install all packages
    if [ -f "$REPOPATH/requirements_test.txt" ]; then
      (
        cd $REPOPATH
        echo "Initializing python virtual environment in $REPOPATH/.venv folder"
        python3 -m venv .venv
        .venv/bin/pip install --upgrade pip wheel
        .venv/bin/pip install -r requirements_test.txt
        # echo "Copy environment variables"
      )
      echo
      echo "Done"
    fi
  else
    echo "Skipping $REPO because it already exists."
  fi
  echo
done

echo "Setup vendor repositories"
mkdir -p vendor
(
  cd vendor && \
  test ! -d docker-postgres-multi && \
  git clone git@github.com:lmm-git/docker-postgres-multi.git
)
# replace FROM line to make postgres version modifiable
sed -i \
  '/FROM postgres:9.6/c\ARG POSTGRES_VERSION=latest\nFROM postgres:$POSTGRES_VERSION' \
  vendor/docker-postgres-multi/Dockerfile
