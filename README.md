# local-workspace

## Setup

1. Ensure system requirements are met.
    - `python==3.6`
    - `ruby==2.5.1` with `bundler==1.16.6` gem
    - `node==8.x`
    - `GNU parallel`

    Add following when using docker:
    - `docker>=18.09.3`
    - `docker-compose>=1.22.0`

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
    127.0.0.1     db
    127.0.0.1     redis
    127.0.0.1     es
    ```

3. Clone repos defined in `repolist` file with `make clone` into `$WORKSPACE_DIR` which defaults to parent directory.

## Usage

- `make update` updates all repositories in `$WORKSPACE_DIR` with installing/updating python/npm/gem packages

### Services on host and dbs in docker

Testing services:

- `make ultimate` setups everything up
- go to `<service-domain>:<port>` to test services directly, for example `soo.trade.great:8008`
- `ctrl+c` from tab where services are running
- `make stop-dbs` stops db containers

Testing services via proxy:

- `make ultimate` setups everything up
- `make run-proxy` and go to `local-proxy.trade.great` to explore website as it is in prod environments through proxy container
- `ctrl+c` from tab where services are running
- `make stop-dbs` stops db containers

Working on individual repos:

- `make ultimate` setups everything up
- open new terminal tab
- `source scripts/activate.sh` loads workspace utility functions
- `work <repo>` steps into `<repo>` and sets up working environment for it
- `fuser -k $PORT/tcp` kills webserver for this repo
- `make run` runs webserver in separate tab
- `ctrl+c` stops `<repo>` webserver
- go back to tab where all services are running
- `ctrl+c` kills runing servers
- `make run-all` reruns all services
- open new terminal tab
- `work <another-repo>` changes working environment for `<another-repo>`
- `fuser -k $PORT/tcp` kills webserver for this repo
- `make run` runs webserver in separate tab
- `ctrl+c` stops `<repo>` webserver
- `ctrl+c` from tab where services are running
- `make stop-dbs` stops db containers

### All in docker

- `make ultimate` cleans, builds, runs, migrates, loads fixtures and collects statics for all containers

### All on host

TODO

## TODO

- ability to run all in docker
- nginx config which will route services which are in same domain
- create local services graph using docker-compose-viz
