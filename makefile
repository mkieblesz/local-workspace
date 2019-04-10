INIT_DBS := \
	psql -t -c '\du' | cut -d \| -f 1 | grep -qw debug || psql -c \"CREATE USER debug WITH PASSWORD 'debug' CREATEDB; ALTER USER debug WITH SUPERUSER;\"; \
	psql -lqt | cut -d \| -f 1 | grep -qw directory_api_debug || createdb --owner=debug directory_api_debug; \
	psql -lqt | cut -d \| -f 1 | grep -qw sso_debug || createdb --owner=debug sso_debug; \
	psql -lqt | cut -d \| -f 1 | grep -qw navigator || createdb --owner=debug navigator; \
	psql -lqt | cut -d \| -f 1 | grep -qw directory_cms_debug || createdb --owner=debug directory_cms_debug; \
	psql -lqt | cut -d \| -f 1 | grep -qw directory_forms_api_debug || createdb --owner=debug directory_forms_api_debug; \
	psql -lqt | cut -d \| -f 1 | grep -qw export_opportunities_dev_zeus || createdb --owner=debug export_opportunities_dev_zeus;

DROP_DBS := \
	dropdb --if-exists directory_api_debug; \
	dropdb --if-exists sso_debug; \
	dropdb --if-exists navigator; \
	dropdb --if-exists directory_cms_debug; \
	dropdb --if-exists directory_forms_api_debug; \
	dropdb --if-exists export_opportunities_dev_zeus; \
	dropuser --if-exists debug;

clone:
	@./scripts/clone.sh

update:
	@./scripts/update.sh

patch:
	@./scripts/patch.sh

kill-dbs:
	docker-compose kill db redis es && docker-compose rm --force db redis es

kill-all:
	docker-compose kill && docker-compose rm --force

build-all:
	docker-compose build

create-dbs:
	docker-compose exec --user postgres db bash -c "$(INIT_DBS)"

drop-dbs:
	docker-compose exec --user postgres db bash -c "$(DROP_DBS)"
	# sudo rm -r tmp

recreate-dbs: drop-dbs create-dbs
	@./scripts/make_host.sh migrate
	@./scripts/make_host.sh load-fixtures

run-dbs:
	docker-compose up -d db redis es
	@until docker-compose exec --user postgres db pg_isready | \
		grep -qm 1 "accepting connections"; do sleep 1; echo "Waiting for postgres" ; done
	@echo "Postgres accepting connections"
	@until curl -s -o /dev/null -w ''%{http_code}'' localhost:9200 | \
		grep -qm 1 "200"; do sleep 1; echo "Waiting for elastic search" ; done
	@echo "Elastic search accepting connections"

run-all:
	@./scripts/make_parallel.sh run

run-proxy:
	docker-compose up -d proxy

ultimate:
	make kill-dbs
	@./scripts/make_host.sh clean
	make run-dbs
	make create-dbs
	# applying all migrations takes ~30min regardless if it's run in parallel or not
	# when no new migrations takes ~1min
	@./scripts/make_host.sh migrate
	@./scripts/make_host.sh load-fixtures
	@./scripts/make_host.sh collect-assets
	# starting all dev servers takes ~1min
	make run-all

ultimate-docker:
	make kill-all
	@./scripts/make_host.sh clean
	make build-all
	make run-dbs
	make create-dbs

	docker-compose up -d
	# migrates after because container have to be started
	@./scripts/make_compose.sh migrate
	@./scripts/make_compose.sh load-fixtures
	@./scripts/make_compose.sh collect-assets