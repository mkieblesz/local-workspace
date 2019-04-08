clone:
	@./scripts/clone.sh

update:
	@./scripts/update.sh

# PROXY TARGETS
clean:
	@echo "Kill all containers and processes"

build:
	@echo "Building app images"

create-dbs:
	@echo "Creating databases"

recreate-dbs:
	@echo "Drops databases"
	make create-dbs migrate load-fixtures

migrate:
	@echo "Migrate database for each app"

load-fixtures:
	@echo "Loading fixtures"

ultimate:
	@./scripts/make.sh ultimate
