#!/bin/bash

source config.sh

echo "Do you have Python 3.6 installed? [Y/n]"
read python_installed
if [ ! -z $python_installed ] && [ $python_installed == "n" ]; then
  echo
  echo "Please install Python 3.6 on your system"
  echo
  exit 0
fi

echo "Do you have Ruby 2.5.1 installed? [Y/n]"
read ruby_installed
if [ ! -z $ruby_installed ] && [ $ruby_installed == "n" ]; then
  echo
  echo "Please install Ruby 2.5.1 on your system"
  echo
  exit 0
fi

echo "Install ruby and bundler"
gem install bundler -v 1.16.3
gem install bundler -v 1.16.6

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

    if [ -f "$REPOPATH/requirements_test.txt" ]; then
      (
        cd $REPOPATH
        echo "Initializing python virtual environment in $REPOPATH/.venv folder"
        python3 -m venv .venv
        .venv/bin/pip install --upgrade pip wheel
        .venv/bin/pip install -r requirements_test.txt
        # echo "Copy environment variables"
      )
    elif [ -f "$REPOPATH/Gemfile" ]; then
      (
        cd $REPOPATH
        echo "Installing gems"
        bundle _1.16.6_ install
      )
    fi
    echo
    echo "Done"
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
