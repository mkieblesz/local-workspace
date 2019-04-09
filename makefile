clone:
	@./scripts/clone.sh

update:
	@./scripts/update.sh

kill-all:
	docker-compose kill && docker-compose rm --force

clean-all: kill-all
	@./scripts/make.sh clean

build-all:
	docker-compose build

create-db-all:
	docker-compose exec --user postgres db psql -c "CREATE USER debug WITH PASSWORD 'debug' CREATEDB;"
	docker-compose exec --user postgres db createdb --owner=debug directory_api_debug
	docker-compose exec --user postgres db createdb --owner=debug sso_debug
	docker-compose exec --user postgres db createdb --owner=debug navigator
	docker-compose exec --user postgres db createdb --owner=debug directory_cms_debug
	docker-compose exec --user postgres db createdb --owner=debug directory_forms_api_debug
	docker-compose exec --user postgres db createdb --owner=debug export_opportunities_dev_zeus

drop-db-all:
	docker-compose exec --user postgres db dropdb directory_api_debug
	docker-compose exec --user postgres db dropdb sso_debug
	docker-compose exec --user postgres db dropdb navigator
	docker-compose exec --user postgres db dropdb directory_cms_debug
	docker-compose exec --user postgres db dropdb directory_forms_api_debug
	docker-compose exec --user postgres db dropdb export_opportunities_dev_zeus
	docker-compose exec --user postgres db dropuser debug

recreate-db-all:
	make drop-db-all create-db-all migrate-host-all load-fixtures-host-all

migrate-host-all:
	@./scripts/make.sh migrate

load-fixtures-host-all:
	@./scripts/make.sh load-fixtures

collect-assets-host-all:
	@./scripts/make.sh collect-assets

run-dbs:
	docker-compose up -d db redis es
	sleep 5

run-all:
	docker-compose up -d

run-all-host:
	@./scripts/make.sh make run

ultimate:
	make clean-all
	make build-all
	make run-dbs
	make create-db-all

ultimate-host:
	make clean-all
	make run-dbs
	make create-db-all
	make migrate-host-all
	make load-fixtures-host-all
	make collect-assets-host-all
	make run-all-host
