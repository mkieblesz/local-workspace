#!/bin/bash

# tells for loop to list items by new line
IFS=$'\n'

for SERVICE in `ls "services/"`; do
  # only for services for which make target exists
  if [ -f "services/$SERVICE/makefile" ] && grep -Fq "$1:" services/$SERVICE/makefile; then
    echo "Running \"make $1\" for $SERVICE"
    (
      cd services/$SERVICE
      COMPOSEFILE=$(pwd)/docker-compose.yml make $1
    )
  else
    echo "Target $1 doesn't exist in services/$SERVICE/makefile"
  fi
done
