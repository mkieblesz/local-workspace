# local-workspace

This repo aims to make setup and development of uktrade apps easier and faster.

1. [Design Goals](#design-goals)
2. [Setup](#setup)
3. [First run](#first-run)
4. [Next run](#next-run)
5. [Utilities](#utilities)
6. [Troubleshooting](#troubleshooting)
7. [Contributing](#contributing)

## Design goals

* single command starts everything from no database to **ready to browse state**
* erase everything and respawn with no issues
* simple and clear setup process for new developers
* different types of workflows
    * [recommended](#recommended) - dbs in docker, services on host
    * [host only](#host-only)
    * [docker only](#docker-only)
* local environment as close as possible to dev
* ability to run predefined set of services on host and docker (currently 13 services)
* transparent command execution, whatever is executed from this repo can be executed from service repo
* ease of [integrating new repos](#integrating-new-service)
* flat and simple [file stricture](#file-stricture)

Also some designe goals were set for each service repo.

* ability to run commands from makefile directly in command line without worrying about env vars
* cleary defined steps of development via new makefile as local management interface
    * clean
    * install
    * migrate
    * load fixtures (as similar as possible to dev)
    * compile assets
    * collect assets
    * run
    * run-celery
    * (do development)
    * test (`lint-<language>` and `test-<language>`)

## Setup

Before jumping into developing uktrade service ensure you understand what is required.

### Program dependencies

Running `./tests/check_requirements.sh` will check if you have all dependencies installed.

* `python>=3.6`
* `ruby==2.5.5` with `bundler==1.16.6` gem
* `node==8.x`
* `GNU parallel` used for running commands in parallel
* `cf` cloud foundry for pulling cms fixtures from dev environment
* `jq` for extracting json keys from command output
* `curl` for making http requests from command line

Having docker is necessary for recommended and docker only workflows.

* `docker>=18.09.3`
* `docker-compose>=1.22.0`

In case you don't want to use docker you will have to install and manage databases on host manually.

* `postgresql==9.5`
* `redis==3.2.12`
* `elasticsearch==5.6.8`

### Host file changes

Update hosts file, most likely located in `/etc/hosts` with following lines.

    127.0.0.1     api.trade.great
    127.0.0.1     buyer.trade.great
    127.0.0.1     opportunities.trade.great
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

### Repolist file

By default all services listed in `repolist` file are included into your workflow. It's possible to exclude services by prepending line with `#` or use different repolist file altogether by exporting `REPO_LIST_FILENAME` environment variable.

```bash
export REPO_LIST_FILENAME=repolist-soo
```

This will replace default `repolist` file to `repolist-soo` as source for repository definition.

When cloning repos version name is taken into account - each line of repolist file follows `<repo-name>@<version>` format. Version can be git `branch`, `tag`, `release` or `commit hash`. If no version is specified default github branch is pulled.

### Cms fixtures

This step is necessary to run some services, mainly to serve landing pages which are stored in cms database.

To do that export cloud foundry username which is your email and password. This is necessary to login to cloud foundry `directory-cms-dev` app in `directory-dev` space to create fixture dump and scp it to local.

```bash
export $CF_USERNAME=<your-username>
export $CF_PASSWORD="<your-password>"
./scripts/eval.sh cms ./scripts/pull_fixtures.sh
```

Once fixtures are downloaded running this script again won't make an effect.

## First run

`make clone patch` to clone and patch all repos defined in repolist file. After finishing follow steps for workflow of your choice.

### Recommended

It's recommended to run dbs in docker with the use of docker compose and services on host. This avoids complications with dbs setup and maintenance and ease of development - no need to execing into machine, more resources available etc. On the other hand you will have to have all repo requirements satisfied on local.

* `make ultimate` starts everything up; will take up to 1 hour, mainly because of cms migrations
* `./tests/check_ready.sh` will check if services are ready for browsing, this should fail because cold cache is not populated
* `./scripts/eval.sh cms make -f new_makefile run-celery` will run celery, keep it for few seconds to populate cold cache
* `ctrl+c` to quit celery
* `./tests/check_ready.sh` should succeed
* (do development/browse services)
* `ctrl+c` from tab where services are running
* `make kill-dbs` shuts down db containers

### Host only

First ensure dbs are running on host and redis config enables to run 200 databases.

* `make ultimate-host`
* `./tests/check_ready.sh` will check if services are ready for browsing, this should fail because cold cache is not populated
* `./scripts/eval.sh cms make -f new_makefile run-celery` will run celery, keep it for few seconds to populate the cache
* `ctrl+c` to quit celery
* `./tests/check_ready.sh` should succeed
* (do development/browse services)
* `ctrl+c` kills runing servers

### Docker only

* `make ultimate-docker` sets everything up in docker
* `./tests/check_ready.sh`  will check if services are ready for browsing, this should fail because cold cache is not populated
* `docker-compose -f docker-compose.services.yml exec cms make -f new_makefile run-celery` will run celery, keep it for few seconds to populate the cache
* `ctrl+c` to quit celery
* `./tests/check_ready.sh` should succeed
* (do development/browse services)
* `make clean-docker` will shut down service and db containers and chown with current user all repos defined in the list

## Next run

This is example of recommended workflow.

* `make run` starts everything up (dbs and services) or `make run-dbs` if you only need to work on one service
* open new terminal tab

    ```bash
    source scripts/activate.sh domestic  # source great-domestic-ui repo environment variables and cd into it, can also use full name
    ```

    Now you can run any commands without worrying about environment variables. To go into debugger mode you will have to start server in current terminal tab.

    ```bash
    fuser -k $PORT/tcp  # stops running server being run by parallel so you can debug directly
    make -f new_makefile run
    ```

    Now you can go into debugger. Once `./scripts/activate.sh` was run you can change environment to another repo with `work` function.

    ```bash
    work soo  # deactivates domestic environment and sources navigator
    work api  # deactivates soo environment and sources directory-api
    ```

    You can also add work function to your `.profile` so you will be able to activate working environment from any directory.

    ```bash
    # uktrade functions
    work() {
        cd /home/mateusz/Projects/uktrade-workspace/local-workspace
        source scripts/activate.sh
        work $1
    }
    ```

* `ctrl+c` from tab where services are running
* `make kill-dbs` shuts down db containers

Please refer to `makefile` for more options.

## Utilities

* update all repos to latest version with `make update`
* run command in all repos with `./scripts/eval_all.sh '<command>'`
* reinstall all repo required packages with `make remove-installs create-venvs; ./scripts/make_host.sh install`
* display duration of previous command execution for each repo with `source scripts/config.sh; parse_duration_log`

## Troubleshooting

* debugging container not starting because of broken command script

    When container has problems starting override default command in service definition in `docker-compose.services.yml` file and exec into container to debug.

    ```yml
    command: /bin/bash -x -c 'while true; do sleep 60; done'
    ```

* problem with too many containers

    Docker creates container from image for the first time you run it, after it reuses container unless specified differently. Sometimes it's usefull to just remove all containers so all of them will get recreated after next run.

    ```bash
    docker rm -f -v $(docker ps -a | awk '{print $1}' | sed "1 d")
    ```

## Contributing

### Testing

When contributing ensure that entire setup works both for host and docker workflows.

To test workflows please look at `tests/test_host.sh` and `tests/test_docker.sh` scripts. Running them will copy this repository to temporary location and run full workflow setup with timing.

You need to pass `CF_USERNAME` and `CF_PASSWORD` to the script to test with pulling and loading cms fixtures, otherwise healtchech at the end will fail since services need landing pages to be present in cms database.

```bash
export CF_USERNAME=<cf-username>
export CF_PASSWOR="<cf-password>"
./tests/test_host.sh
```

### Integrating new service

* add git repo slug to `repolist`, perhaps add `repolist-<service-acronym>` file with repos which are required to be running when developing `<service-name>`
* add `patch/<service-name>` directory with new files and git patch which will have to be applied to repo
* add acronym to ACRONYM_MAP in `scripts/config.sh` file
* add corresponding service to `docker-compose.services.yml` file
* ensure [design goals](#design-goals) are met

### File stricture

    uktrade                         # workspace folder containing all repos from github.com/uktrade
    │
    └───local-workspace             # THIS REPO
    │   │   docker-compose.yml      # used for managing all database containers
    │   │   docker-compose.services.yml  # used for managing all service containers
    │   │   makefile                # workspace task management
    │   │   repolist                # list of all repos
    │   │   repolist-<service-name> # list of repos required by specific service workflow
    │   │
    │   └───docker                  # extra containers not having it's own repo in uktrade
    │   │   │
    │   │   └───redis
    │   │   │   redis.conf          # modified default redis config, enables up to 200 databases
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
    │   │   config.sh               # updates environment with utility functions and env vars
    │   │   eval_all.sh             # passed command will be executed inside all repositories
    │   │   eval.sh                 # passed command will be executed inside repository with activated environment
    │   │   make_docker.sh          # executes make target in docker container for each repo
    │   │   make_host.sh            # executes make target for each repo on host
    │   │   make_parallel.sh        # executes make target for each repo on host in parallel
    │   │   patch.sh                # copies files and applies git patch to repos listed in patches/ directory
    │   │   update.sh               # pulls latest changes for each repo
    │   |
    │   └───logs
    │   │   <number>.order_log      # file used to record last repo output which then is used by gnu parallel to multiplex output
    │   │   common.duration_log     # timing of run commands using eval.sh and make_docker.sh scripts
    │   │   <custom>.duration_log   # same as the above but used by test scripts only
    │   |
    │   └───tmp
    │   │   |
    │   │   └───volumes             # postgres, redis and elastic search docker volumes are stored so no need to remigrate each time
    │   │   |
    │   │   └───ultimate            # directory created by `tests/test_host.sh` script with setup of entire workspace
    │   │   |
    │   │   └───ultimate-docker     # directory created by `tests/test_docker.sh` script with setup of entire workspace
    │   |
    │   └───tests
    │   │   test_docker.sh          # tests entire setup from ground up for all in docker
    │   │   test_host.sh            # tests entire setup from ground up for dbs in docker rest on host
    │   │   requirements.sh         # checks if system requirements are met
    │   │   check_ready.sh          # check if services are ready for browsing
    │
    └───directory-api
    │
    └───directory-cms
    │
    └───great-domestic-ui
    |
    |   ...

### TODO

Tasks for this repo:

* implement rest of test and celery targets
* implement rest of make targets if any left
* make it work on mac
* check dependencies looks for global ruby, not ruby defined with .ruby-version file placed in service repo
* inclue rest of the service repos, in total should be around 25
* consider changing eval to `https://stackoverflow.com/a/14061950/11060504`

Tasks for service repos:

* merge patches and new files; update `new_<filename>` references
* remove compiled assets from repos and put it to build artifacts
* by default settings should have local development variables, not production - a lot of variables from `.env` files could be removed
