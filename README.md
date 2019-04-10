# local-workspace

## Intro

Directory structure for uktrade workspace assumed by this repo.

```text
    uktrade                         # workspace folder containing all repos from github.com/uktrade
    │
    └───local-workspace             # THIS REPO
    │   │   docker-compose.yml      # used for managing all docker containers
    │   │   makefile                # workspace task management
    │   │
    │   └───docker                  # extra containers not having it's own repo in uktrade
    │   │   │
    │   │   └───proxy
    │   │   │   default.conf        # nginx config with proxy passing
    │   │   │
    │   │   └───redis
    │   │   │   redis.conf          # modified default redis config, enables up to 200 databases binds to 0.0.0.0
    │   │   │   ...
    │   │
    │   └───patches                 # repo files which will need to be merged (currently they are just copied with "new_" prefix)
    │   │   │
    │   |   └───directory-api
    │   │   │   makefile            # makefile is in each repo updated and simplified
    │   │   │   .env                # env variables for local dev
    │   │   │   .env.test           # extra env variables required for testing
    │   │   │   ...
    │   │   │
    │   |   └───directory-cms
    │   │   │
    │   |   └───great-domestic-ui
    │   |   |
    │   |   |   ...
    │   |
    │   └───scripts
    │   │   activate.sh             # used to activate working environment on host for repo
    │   │   clone.sh                # clones all repos defined in `repolist` file
    │   │   config.sh               # updates WORKSPACE_DIR and WORKSPACE_REPO_DIR env vars
    │   │   eval.sh                 # passed command will be executed inside repository with activated environment
    │   │   make_compose.sh         # executes make target in docker container for each repo if running
    │   │   make_host.sh            # executes make target for each repo on host using eval.sh
    │   │   make_parallel.sh        # used to run all webservers in one shell, executes make target for each repo on host in parallel
    │   │   patch.sh                # copies fields which will have to be patched to each repo
    │   │   update.sh               # pulls latest changes in each repo
    │   |
    │   └───tmp
    │       |
    │       └───volumes             # postgres, redis and elastic search docker volumes are stored so no need to remigrate each time

    └───directory-api
    │
    └───directory-cms
    │
    └───great-domestic-ui
    |
    |   ...
```

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
    127.0.0.1     opportunities.export.great
    127.0.0.1     sso.trade.great
    127.0.0.1     sso-proxy.trade.great
    127.0.0.1     supplier.trade.great
    127.0.0.1     profile.trade.great
    127.0.0.1     exred.trade.great
    127.0.0.1     soo.trade.great
    127.0.0.1     cms.trade.great
    127.0.0.1     forms.trade.great
    127.0.0.1     international.trade.great
    127.0.0.1     proxy.trade.great
    # same as compose containers so it will work with
    # one set of env vars both on host and docker
    127.0.0.1     db
    127.0.0.1     redis
    127.0.0.1     es
    ```

3. Clone repos defined in `repolist` file with `make clone` into `$WORKSPACE_DIR` which defaults to parent directory.

## Usage

- `make update` updates all repositories in `$WORKSPACE_DIR` with installing/updating python/npm/gem packages
- `make patch` patches repos with changes required

### Services on host and dbs in docker

Testing services:

- `make ultimate` setups everything up
- go to `<service-domain>:<port>` to test services directly, for example `soo.trade.great:8008`
- `ctrl+c` from tab where services are running
- `make kill-dbs` kills db containers

Testing services via proxy:

- `make run-proxy ultimate`
- go to `proxy.trade.great` to test services as they are in prod environments through proxy container
- `ctrl+c` from tab where services are running
- `make kill-dbs` kills db containers

Working on individual repos:

- `make ultimate` setups everything up
- open new terminal tab

    ```bash
    source scripts/activate.sh
    work <repo>
    fuser -k $PORT/tcp
    make run
    ```

- `ctrl+c` stops `<repo>` webserver
- go back to tab where all services are running
- `ctrl+c` kills runing servers
- `make run-all` reruns all services
- open new terminal tab

    ```bash
    source scripts/activate.sh
    work <another-repo>
    fuser -k $PORT/tcp
    make run
    ```

- `ctrl+c` stops `<repo>` webserver
- `ctrl+c` from tab where services are running
- `make kill-dbs` kills db containers

### All in docker

- `make ultimate-docker` sets everything up in docker

### All on host

TODO

## Tips

- debugging site-packages in docker

    TODO

- debugging with vscode

    TODO

- debugging broken command scripts

    When container has problems starting override default command in service definition in `docker-compose.yml` file.

    ```yml
    command: /bin/bash -x -c 'while true; do sleep 60; done'
    ```

## TODO

- create dockerfiles
- cleanup env vars
- update nginx config for proxy
- create local services graph using docker-compose-viz
