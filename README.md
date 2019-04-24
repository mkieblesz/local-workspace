# local-workspace

## Intro

1. Features.

    These features where tested on Ubuntu 18.04 only.

    * from cloning this repo to browsing development version of all services defined in `repolist` with one command
    * `dbs in docker + services on host` and `docker only` workflows
    * check out for more in [usage workflows](#usage)

2. Repo updates.

    * running management commands and tests from command line with no worry about environment variables

        * .env file is separated out of makefile, activated by activate command, all/most of them point to local services
        * .env.test file is separated out of makefile and explicitly imported in settings so can run tests from command lin

    * dockerfiles for all services only to be built and used locally
    * updated makefile structure, more or less following `https://github.com/getsentry/sentry/blob/master/Makefile`
    * added fixtures necessary to explore services with authenticated user and cms pages

3. Directory structure for uktrade workspace assumed by this repo.

    ```text
        uktrade                         # workspace folder containing all repos from github.com/uktrade
        │
        └───local-workspace             # THIS REPO
        │   │   docker-compose.yml      # used for managing all database containers
        │   │   docker-compose.services.yml  # used for managing all service containers
        │   │   makefile                # workspace task management
        │   │   repolist                # list of repos currently included in the workflow
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
        │   │   <custom>.duration_log   # same as the above but used by benchmark scripts only
        │   |
        │   └───tmp
        │   │   |
        │   │   └───volumes             # postgres, redis and elastic search docker volumes are stored so no need to remigrate each time
        │   |   |
        │   |   |   ...
        │   |
        │   └───tests
        │   │   benchmark_docker.sh     # tests entire setup from ground up for all in docker
        │   │   benchmark_host.sh       # tests entire setup from ground up for dbs in docker rest on host
        │   │   requirements.sh         # checks if system requirements are met
        │   │   healthcheck.sh               # healthchecks running services
        │
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

    Run `./tests/requirements.sh` to ensure all requirements are met.

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

First run `make clone patch` to clone and patch all repos defined in `repolist`. If you want to omit certain repos from your workflow you can comment them out with `#`. Note that some repos are dependent on others.

### Services on hosts and dbs in docker

It's recommended to run dbs in docker with the use of docker compose and services on host. This avoids complications with dbs setup and maintenance and ease of development - no need to execing into machine.

Testing services:

* `make ultimate` starts everything up
* `./tests/healthcheck.sh` will healthcheck services, which will fail because cold cache is not populated
* `./scripts/eval.sh cms make -f new_makefile run-celery` will run celery, keep it for few seconds to populate the cache
* `ctrl+c` to quit celery
* `./tests/healthcheck.sh` should succeed
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
* `make run` reruns all services
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
* `./tests/healthcheck.sh` will healthcheck services, which will fail because cold cache is not populated
* `./scripts/eval.sh cms make -f new_makefile run-celery` will run celery, keep it for few seconds to populate the cache
* `ctrl+c` to quit celery
* `./tests/healthcheck.sh` should succeed
* browse services
* `make clean-docker` will shut

### All on host

First ensure dbs are running on host and redis config enables to run 200 databases.

* `make ultimate-host` sets everything up in docker
* `./tests/healthcheck.sh` will healthcheck services, which will fail because cold cache is not populated
* `./scripts/eval.sh cms make -f new_makefile run-celery` will run celery, keep it for few seconds to populate the cache
* `ctrl+c` to quit celery
* `./tests/healthcheck.sh` should succeed
* browse services
* `ctrl+c` kills runing servers

## Adding new service

* add git repo slug to repolist
* add `patch/<service-name>` directory with new files and git patch which will have to be applied to repo
* ensure structure of makefile is same as in other services, same goes for other files
* add acronym to ACRONYM_MAP in `scripts/config.sh` file
* add corresponding service to `docker-compose.yml` file

## Tips

* debugging broken command scripts

    When container has problems starting override default command in service definition in `docker-compose.yml` file and exec into container to debug.

    ```yml
    command: /bin/bash -x -c 'while true; do sleep 60; done'
    ```

* removing all containers

    Docker creates container from image for the first time you run it, after it reuses container unless specified differently. Sometimes it's usefull to just remove all containers.

    ```bash
    docker rm -v $(docker ps -a | awk '{print $1}' | sed "1 d")
    ```

## Test

To test host workflow please look at `tests/benchmark_host.sh` and `tests/benchmark_docker.sh` scripts. Running them will copy current repository to temporary location and run full workflow setup with timing.

You need to pass CF_USERNAME and CF_PASSWORD to the script to test with pulling and loading cms fixtures, otherwise healtcheck is going to fail.

```bash
export CF_USERNAME=<cf-username>
export CF_PASSWOR="<cf-password>"
./tests/benchmark_host.sh
```

## TODO

### Tasks for this repo

* implement rest of test and celery targets
* implement rest of make targets if any left
* make it work on mac
* inclue rest of the service repos, in total should be around 25
* consider changing eval to `https://stackoverflow.com/a/14061950/11060504`
* consider removing docker stuff (just leave main compose for running dbs) from workflows (just leave ultimate and ultimate-host)

### Tasks for service repos

* merge patches and new files; update `new_<filename>` references
* remove compiled assets from repos and put it to build artifacts