#!/bin/bash

source scripts/config.sh

# tells for loop to list items by new line
IFS=$'\n'

for SERVICE in `ls "services/"`; do
  # only for services for which make target exists
  if [ -f "services/$SERVICE/makefile" ] && grep -Fq "$1:" services/$SERVICE/makefile; then
    ./scripts/eval.sh $SERVICE pmake $1
  fi
done
