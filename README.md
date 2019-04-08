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

## Usage

- `make update` updates all repositories in `$WORKSPACE_DIR` with installing/updating python/npm/gem packages.

### All in docker

- `make ultimate-all` cleans, builds, runs and prepares all containers for local development

### Services on host and dbs in docker

- `make ultimate-all-host` same as `ultimate-all` but services are run on host
- to work from repository directory run following from command line in this repo

    ```bash
    # REPO=<repo-name-here>
    REPO=navigator
    source config.sh
    REPO_PATH=$WORKSPACE_DIR/$REPO
    REPO_PATCH=$(pwd)/services/$REPO
    test -d $REPO_PATH/.venv && source $REPO_PATH/.venv/bin/activate
    test -f $REPO_PATCH/.env && set -o allexport; source $REPO_PATCH/.env; set +o allexport
    fuser -k $PORT/tcp
    cd $REPO_PATH
    alias m="make -f  $REPO_PATCH/makefile"
    m run
    ```

### All on host

TODO

## TODO

- ability to run apps on host via makefile
- ability to migrate dbs via makefile
- ability load fixtures/patch export opportunities seeds.rb via makefile
- ability to run apps via makefile (using parrallel)
- dockerfiles for apps
- nginx config which will route services which are in same domain
- create local services graph using docker-compose-viz
