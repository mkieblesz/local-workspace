INIT_DBS := \
	psql -t -c '\du' | cut -d \| -f 1 | grep -qw lol || psql -c \"CREATE USER lol WITH PASSWORD 'lol' CREATEDB; ALTER USER lol WITH SUPERUSER;\"; \
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

stop-all:
	docker-compose down

create-dbs:
	docker-compose exec --user postgres db bash -c "$(INIT_DBS)"

drop-dbs:
	docker-compose exec --user postgres db bash -c "$(DROP_DBS)"

recreate-dbs: drop-dbs create-dbs
	@./scripts/make.sh migrate
	@./scripts/make.sh load-fixtures

run-dbs:
	docker-compose up -d db redis es
	sleep 10

run-all:
	@./scripts/parallel_make.sh run

run-proxy:
	docker-compose up -d proxy

ultimate:
	make kill-dbs
	@./scripts/make.sh clean
	make run-dbs
	make create-dbs
	# applying all migrations takes ~30min regardless if it's run in parallel or not
	# when no new migrations takes ~1min
	@./scripts/make.sh migrate
	@./scripts/make.sh load-fixtures
	@./scripts/make.sh collect-assets
	# starting all dev servers takes ~1min
	make run-all

ultimate-docker:
	docker-compose down
	make run-dbs
	make create-dbs
	make docker-compose up -d
