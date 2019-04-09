#!/bin/bash

source scripts/config.sh

if [ -d "$WORKSPACE_DIR/$1" ]; then
  (
    source scripts/activate.sh $1
    eval "${@:2}"
  )
else
  echo "Repo not found"
fi
