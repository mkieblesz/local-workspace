#!/bin/bash

source scripts/config.sh

echo "Do you have Python 3.6 installed? [Y/n]"
read python_installed
if [ ! -z $python_installed ] && [ $python_installed == "n" ]; then
    echo
    echo "Please install Python 3.6 on your system"
    echo
    exit 0
fi

echo "Do you have Ruby 2.5.5 with bundler 1.16.6 gem installed? [Y/n]"
read ruby_installed
if [ ! -z $ruby_installed ] && [ $ruby_installed == "n" ]; then
    echo
    echo "Please install Ruby 2.5.5 with bundler 1.16.6 gem on your system"
    echo
    exit 0
fi

echo "Do you have Node 8.x installed? [Y/n]"
read node_installed
if [ ! -z $node_installed ] && [ $node_installed == "n" ]; then
    echo
    echo "Please install Node 8.x on your system"
    echo
    exit 0
fi

echo "Do you have docker>18.09.3 and docker-compose>1.22.0 installed? [Y/n]"
read docker_installed
if [ ! -z $docker_installed ] && [ $docker_installed == "n" ]; then
    echo
    echo "Please install docker>18.09.3 and docker-compose>1.22.0 on your system"
    echo
    exit 0
fi

for REPO in "${REPO_LIST[@]}"; do
    REPOPATH=$WORKSPACE_DIR/$REPO

    if [ ! -d "$REPOPATH" ]; then
        echo "Cloning $REPO"
        echo
        (
            cd $WORKSPACE_DIR
            VERSION=${VERSION_MAP[$REPO]}
            if [ ! -z $VERSION ]; then
                git clone git@github.com:uktrade/$REPO.git@$VERSION
            else
                git clone git@github.com:uktrade/$REPO.git
            fi
        )
        echo

        echo "Done"
    else
        echo "Skipping $REPO because it already exists."
    fi
    echo
done
