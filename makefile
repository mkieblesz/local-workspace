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

clean:
	rm -rf logs/*

clone:
	@./scripts/clone.sh

update:
	@./scripts/update.sh

create-venvs:
	@./scripts/eval_all.sh 'test ! -d .venv && test -f requirements_test.txt && python3.6 -m venv .venv && .venv/bin/pip install --upgrade pip wheel'

remove-installs:
	@./scripts/eval_all.sh 'rm -rf .venv vendor/bundle node_modules'

patch:
	@./scripts/patch.sh

create-dbs:
	docker-compose exec --user postgres db bash -c "$(INIT_DBS)"

drop-dbs:
	docker-compose exec --user postgres db bash -c "$(DROP_DBS)"
	# sudo rm -r tmp

recreate-dbs: drop-dbs create-dbs
	@./scripts/make_host.sh migrate
	@./scripts/make_host.sh load-fixtures

kill-dbs:
	docker-compose kill
	docker-compose rm --force
	docker-compose down

kill-docker:
	docker-compose -f docker-compose.services.yml kill
	docker-compose -f docker-compose.services.yml rm --force
	docker-compose -f docker-compose.services.yml down

clean-docker: kill-dbs kill-docker
	@sudo ./scripts/eval_all.sh chown -R $(USER):$(USER) .

run-dbs:
	docker-compose up -d
	@until docker-compose exec --user postgres db pg_isready | \
		grep -qm 1 "accepting connections"; do sleep 1; echo "Waiting for postgres" ; done
	@echo "Postgres accepting connections"
	@until curl -s -o /dev/null -w ''%{http_code}'' localhost:9200 | \
		grep -qm 1 "200"; do sleep 1; echo "Waiting for elastic search" ; done
	@echo "Elastic search accepting connections"

run-services:
	@./scripts/make_parallel.sh run

run: run-dbs run-services

run-docker: run-dbs
	./scripts/run_docker.sh

ultimate:
	./scripts/make_host.sh clean
	make run-dbs
	make create-dbs

	make create-venvs
	./scripts/make_host.sh install
	./scripts/make_host.sh migrate
	./scripts/make_host.sh load-fixtures
	# ./scripts/make_host.sh compile-assets
	./scripts/make_host.sh collect-assets
	make run

ultimate-docker:
	make kill-dbs
	./scripts/make_host.sh clean
	docker-compose build

	make run-dbs
	make create-dbs
	make run-docker
	./scripts/make_docker.sh migrate
	./scripts/make_docker.sh load-fixtures
	# ./scripts/make_docker.sh compile-assets
	./scripts/make_docker.sh collect-assets

ultimate-host:
	./scripts/make_host.sh clean
	# assuming dbs are already running
	$(INIT_DBS)

	make create-venvs
	./scripts/make_host.sh install
	./scripts/make_host.sh migrate
	./scripts/make_host.sh load-fixtures
	# ./scripts/make_host.sh compile-assets
	./scripts/make_host.sh collect-assets
	make run-services
