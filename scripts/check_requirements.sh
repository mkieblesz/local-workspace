#!/bin/bash

check_command_exists() {
    COMMAND=$1
    if [ -z $(command -v $COMMAND) ]; then
        echo "[ERROR] $COMMAND: command not available"
    else
        echo "[OK] $COMMAND: command exists"
    fi
}

check_version_minimal() {
    COMMAND=$1
    MIN_VER=$2
    CURRENT_VER=$3
    check_command_exists $COMMAND
    if [ ! "$(printf '%s\n' "$MIN_VER" "$CURRENT_VER" | sort -V | head -n1)" = "$MIN_VER" ]; then
        echo "[ERROR] $COMMAND: current version $CURRENT_VER < $MIN_VER"
    else
        echo "[OK] $COMMAND: current version $CURRENT_VER >= $MIN_VER"
    fi
}

check_version_equal() {
    COMMAND=$1
    REQ_VERSION=$2
    CURRENT_VER=$3

    check_command_exists $COMMAND
    if [ $CURRENT_VER != $REQ_VERSION ]; then
        echo "[ERROR] $COMMAND: current version $CURRENT_VER != $REQ_VERSION"
    else
        echo "[OK] $COMMAND: current version $CURRENT_VER == $REQ_VERSION"
    fi
}

check_version_minimal "python3.6" 3.6 $(python3.6 -V | sed -e 's/^Python//')
check_version_equal "ruby" 2.5.5 $(ruby -v | sed -e 's/.*ruby \(.*\)p.*/\1/')
check_version_minimal "docker" 18.09 $(docker -v | sed -e 's/.*version \(.*\),.*/\1/')
check_version_minimal "docker-compose" 1.22 $(docker-compose -v | sed -e 's/.*version \(.*\),.*/\1/')
check_version_minimal "node" 8 $(node -v | tr -d v)
check_command_exists "parallel"
check_command_exists "jq"
check_command_exists "cf"
check_command_exists "curl"
