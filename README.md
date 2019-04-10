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
    127.0.0.1     host-proxy.trade.great
    127.0.0.1     docker-proxy.trade.great
    127.0.0.1     db.trade.great
    127.0.0.1     redis.trade.great
    127.0.0.1     es.trade.great
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

- `make run-host-proxy ultimate`
- go to `local-proxy.trade.great` to test services as they are in prod environments through proxy container
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

## TODO

- create dockerfiles
- cleanup env vars (services/.env.host-proxy and services/.env.docker-proxy and perhaps .env.test for testing)
- update nginx config for host and docker proxy
- create local services graph using docker-compose-viz
