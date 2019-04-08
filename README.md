# local-workspace

## Setup

1. Ensure system requirements are met.

    Running all services in docker:
    - `docker>=18.09.3`
    - `docker-compose>=1.22.0`
    - `node==8.x`

    Add following when running dbs in docker and services on host:
    - `python==3.6`
    - `ruby==2.5.1` with `bundler==1.16.6` gem

    Add following when running everything on host:
    - `postgresql==9.5`
    - `redis==3.2.12`
    - `elasticsearch==5.6.8`

2. Update local hosts file, usually found in `/etc/hosts` with following lines.

    ```Text
    127.0.0.1     api.trade.great
    127.0.0.1     buyer.trade.great
    127.0.0.1     exopps.export.trade.great
    127.0.0.1     sso.trade.great
    127.0.0.1     sso-proxy.trade.great
    127.0.0.1     supplier.trade.great
    127.0.0.1     profile.trade.great
    127.0.0.1     exred.trade.great
    127.0.0.1     soo.trade.great
    127.0.0.1     cms.trade.great
    127.0.0.1     forms.trade.great
    127.0.0.1     international.trade.great
    127.0.0.1     local-proxy.trade.great
    127.0.0.1     db.trade.great
    127.0.0.1     redis.trade.great
    127.0.0.1     es.trade.great
    ```

3. Clone repos defined in `repolist` file with `make clone` into `$WORKSPACE_DIR` which defaults to parent directory.
4. Add following aliases to your `~/.bash_profile`.

    ```bash
    alias make-workspace='make -f <path-of-current_directory>/makefile'
    alias docker-compose-workspace='docker-compose -f <path-of-current_directory>/docker-compose.yml'
    ```

## Usage

### All in docker

- `make update` updates all repositories in `$WORKSPACE_DIR` with installing/updating python/npm/gem packages.
- `make kill-all` kills all running processes/containers
- `make clean-all` kills all processes and removes generated files not included into git repo
- `make build-all` builds docker image for each service defined in `services/` directory
- `make run-all` runs all services
- `make ultimate-all` cleans, builds, runs and prepares all services for local development
- `docker-compose up -d <service-name>` to run specific service and all of it's dependencies

### Services on host and dbs in docker

TODO

### All on host

TODO

## TODO

- sort out networking (host file, readme part)
- docker-compose.base.yml with all apps and default settings
- environment variables for all services
- ability to run apps on host via makefile
- docker-compose.yml with backing-apps
- docker-compose.yml with backing-apps and persistent volumes
- ability to migrate dbs via makefile
- ability load fixtures/patch export opportunities seeds.rb via makefile
- ability to run apps via makefile (using parrallel)
- dockerfiles for apps
- nginx config which will route services which are in same domain
- docker-compose.full.yml which runs all apps and host configuration
- create local services graph using docker-compose-viz
