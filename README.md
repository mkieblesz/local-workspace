# local-services

## Installation

Run `make setup` to clone repositories and setup python virtual environments.

## Updates

To update repos to latest versions run `make update`.

## Usage

Run `make ultimate` to run all services.

## TODO

* add export-opportunities to setup.sh and update.sh (only if required ruby version is installed)
* docker-compose.base.yml with all apps and default settings
* environment variables for all services
* ability to run apps on host via makefile
* docker-compose.yml with backing-apps
* docker-compose.yml with backing-apps and persistent volumes
* ability to migrate dbs via makefile
* ability load fixtures/patch export opportunities seeds.rb via makefile
* ability to run apps via makefile (using parrallel)
* dockerfiles for apps
* nginx config which will route services which are in same domain
* docker-compose.full.yml which runs all apps and host configuration
* create local services graph using docker-compose-viz
