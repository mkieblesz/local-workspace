# local-services

## Setup

1. Make sure you have `python 3.6`, `node 8.x`, `ruby 2.5.1`, `docker>=18.09.3`, `docker-compose>=1.22.0` installed.
2. Update local hosts file, usually found in `/etc/hosts` with following lines.
    - 172.28.0.0      api.trade.great
    - 172.28.0.1      buyer.trade.great
    - 172.28.0.2      exopps.export.trade.great
    - 172.28.0.3      sso.trade.great
    - 172.28.0.4      sso-proxy.trade.great
    - 172.28.0.5      supplier.trade.great
    - 172.28.0.6      profile.trade.great
    - 172.28.0.7      exred.trade.great
    - 172.28.0.8      soo.trade.great
    - 172.28.0.10     cms.trade.great
    - 172.28.0.11     forms.trade.great
    - 172.28.0.12     international.trade.great
    - 172.28.10.0     local-proxy.trade.great
    - 172.28.20.0     db.trade.great
    - 172.28.20.1     redis.trade.great
    - 172.28.20.3     es.trade.great
3. Create workspace directory with `mkdir -p $WORKSPACE_DIR` which defaults to parent directory.
4. Clone repos defined in `repolist` file with `make clone` into `$WORKSPACE_DIR`.

## Usage

- `make update` updates all repositories in `$WORKSPACE_DIR` with installing/updating python/npm/gem packages.
- `make clean` kills all processes and removes generated files not included into git repo
- `make build` builds docker image for all services defined in `services/` directory
- `make run` runs all services
- `make ultimate` cleans, builds, runs and prepares all services

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
