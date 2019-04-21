# local-workspace

## Intro

1. Features.

    These features where tested on Ubuntu 18.04 only.

    * from cloning this repo to browsing development version of all services defined in `repolist` with one command
    * `docker + host` and `docker only (still some issues)` workflows
    * check out for more in [usage workflows](#usage)

2. Upcomming features.

    * check out for more in [todos](#todo)

3. Directory structure for uktrade workspace assumed by this repo.

    ```text
        uktrade                         # workspace folder containing all repos from github.com/uktrade
        │
        └───local-workspace             # THIS REPO
        │   │   docker-compose.yml      # used for managing all docker containers
        │   │   makefile                # workspace task management
        │   │
        │   └───docker                  # extra containers not having it's own repo in uktrade
        │   │   │
        │   │   └───redis
        │   │   │   redis.conf          # modified default redis config, enables up to 200 databases binds to `redis` host
        │   │   │   ...
        │   │
        │   └───patches                 # repo files which will need to be merged (currently they are just copied with "new_" prefix)
        │   │   │
        │   |   └───directory-api
        │   │   │   makefile            # makefile is in each repo updated and simplified
        │   │   │   .env                # env variables for local dev
        │   │   │   .env.test           # extra env variables required for testing
        │   │   │   git.patch           # git patch which will need to be made for the repo
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
        │   │   eval_all.sh             # passed command will be executed inside all repositories
        │   │   eval.sh                 # passed command will be executed inside repository with activated environment
        │   │   make_compose.sh         # executes make target in docker container for each repo
        │   │   make_host.sh            # executes make target for each repo on host
        │   │   make_parallel.sh        # executes make target for each repo on host in parallel
        │   │   patch.sh                # copies files and applies git patch to repos listed in patches/ directory
        │   │   update.sh               # pulls latest changes for each repo
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

    Run `./tests/check_requirements.sh` to ensure all requirements are met.

    * `python>=3.6`
    * `ruby==2.5.5` with `bundler` gem
    * `node==8.x`
    * `GNU parallel` used for running commands in parallel
    * `jq` used for extracting json keys from command line

    Add following when using docker:
    * `docker>=18.09.3`
    * `docker-compose>=1.22.0`

    Add following when running everything on host:
    * `postgresql==9.5`
    * `redis==3.2.12`
    * `elasticsearch==5.6.8`

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
    127.0.0.1     invest.trade.great
    ```

3. Update list of repos in `repolist` file to fit your needs.

    Each line should have following format `<repo-name>@<version>`. Version can be git `branch`, `tag`, `release` or `commit hash`. If no version is specified default branch is pulled as in github.

4. Pull cms fixtures.

    This step is necessary to run some services, mainly to serve landing pages which are stored in cms.

    To do that export cloud foundry username which is your email and password. This is necessary to login to cloud foundry directory-cms-dev app in directory-dev space to create dump.

    ```bash
    export $CF_USERNAME=<your-username>
    export $CF_PASSWORD="<your-password>"
    ./scripts/eval.sh cms ./scripts/pull_fixtures.sh
    ```

    Once fixtures are present running won't make an effect.

## Usage

First run `make clone patch create-venvs` to clone, patch and create virtuale environments for all repos defined in `repolist`. If you want to omit certain repos from your workflow you can comment them out with `#`. Note that some repos are dependent on others.

### Services on host and dbs in docker

Testing services:

* `make ultimate` starts everything up
* browse services
* `ctrl+c` from tab where services are running
* `make kill-docker` shuts down db containers

Working on individual repos:

* `make ultimate` starts everything up
* open new terminal tab

    ```bash
    source scripts/activate.sh
    work <repo>
    fuser -k $PORT/tcp
    make -f new_makefile run
    ```

* `ctrl+c` stops `<repo>` webserver
* go back to tab where all services are running
* `ctrl+c` kills runing servers
* `make run-all` reruns all services
* open new terminal tab

    ```bash
    source scripts/activate.sh
    work <another-repo>
    fuser -k $PORT/tcp
    make -f new_makefile run
    ```

* `ctrl+c` stops `<another-repo>` webserver
* `ctrl+c` from tab where services are running
* `make kill-docker` shuts down db containers

### All in docker

* `make ultimate-docker` sets everything up in docker
* TODO

### All on host

TODO

## Adding new service

TODO

## Tips

* debugging site-packages in docker

    TODO

* debugging with vscode

    TODO

* debugging broken command scripts

    When container has problems starting override default command in service definition in `docker-compose.yml` file and exec into container to debug.

    ```yml
    command: /bin/bash -x -c 'while true; do sleep 60; done'
    ```

## TODO

### Tasks for this repo

* make run all in docker with sanity check work (exoops, directory-sso-profile)
* parse duration log function which will display result
* implement celery targets and add them to ultimate targets in main makefile
* ensure cold cache is loaded in cms upon start (perhaps wait until it does)
* implement rest of test targets
* implement rest of make targets if any left
* make it work on mac

### Tasks for service repos

* merge patches
* remove compiled assets from repos and put it to build artifacts