clone-all:
	@./scripts/clone.sh

update-all:
	@./scripts/update.sh

kill-all:
	docker-compose kill && docker-compose rm --force

clean-all: kill-all
	@./scripts/make.sh clean

create-db-all:
	docker-compose exec --user postgres db psql -t -c '\du' | cut -d \| -f 1 | grep -qw debug || docker-compose exec --user postgres db psql -c "CREATE USER debug WITH PASSWORD 'debug' CREATEDB; ALTER USER debug WITH SUPERUSER;"
	docker-compose exec --user postgres db psql -lqt | cut -d \| -f 1 | grep -qw directory_api_debug || docker-compose exec --user postgres db createdb --owner=debug directory_api_debug
	docker-compose exec --user postgres db psql -lqt | cut -d \| -f 1 | grep -qw sso_debug || docker-compose exec --user postgres db createdb --owner=debug sso_debug
	docker-compose exec --user postgres db psql -lqt | cut -d \| -f 1 | grep -qw navigator || docker-compose exec --user postgres db createdb --owner=debug navigator
	docker-compose exec --user postgres db psql -lqt | cut -d \| -f 1 | grep -qw directory_cms_debug || docker-compose exec --user postgres db createdb --owner=debug directory_cms_debug
	docker-compose exec --user postgres db psql -lqt | cut -d \| -f 1 | grep -qw directory_forms_api_debug || docker-compose exec --user postgres db createdb --owner=debug directory_forms_api_debug
	docker-compose exec --user postgres db psql -lqt | cut -d \| -f 1 | grep -qw export_opportunities_dev_zeus || docker-compose exec --user postgres db createdb --owner=debug export_opportunities_dev_zeus

drop-db-all:
	docker-compose exec --user postgres db dropdb --if-exists directory_api_debug
	docker-compose exec --user postgres db dropdb --if-exists sso_debug
	docker-compose exec --user postgres db dropdb --if-exists navigator
	docker-compose exec --user postgres db dropdb --if-exists directory_cms_debug
	docker-compose exec --user postgres db dropdb --if-exists directory_forms_api_debug
	docker-compose exec --user postgres db dropdb --if-exists export_opportunities_dev_zeus
	docker-compose exec --user postgres db dropuser --if-exists debug

recreate-db-all:
	make drop-db-all create-db-all migrate-all load-fixtures-all

migrate-all:
	@./scripts/make.sh migrate

load-fixtures-all:
	@./scripts/make.sh load-fixtures

collect-assets-all:
	@./scripts/make.sh collect-assets

run-db-all:
	docker-compose up -d db redis es
	sleep 10

run-all:
	@./scripts/parallel_make.sh run

run-proxy:
	docker-compose up -d local-proxy

ultimate:
	make clean-all
	make run-db-all
	make create-db-all
	make migrate-all
	make load-fixtures-all
	make collect-assets-all
	make run-all

ultimate-recreate-dbs:
	make clean-all
	make run-db-all
	make drop-db-all
	make create-db-all
	make migrate-all
	make load-fixtures-all
	make collect-assets-all
	make run-all
