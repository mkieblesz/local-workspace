clean:
	@echo "clean-stuff"

build:
	@echo "Building app images"

migrate:
	python manage.py distributed_migrate --noinput
	python manage.py distributed_elasticsearch_migrate

load-fixtures:
	@echo "Loading fixtures"

ultimate:
	@echo "ultimate ..."
