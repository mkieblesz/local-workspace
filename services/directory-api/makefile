clean:
	@echo "clean-stuff"

build:
	@echo "Building app images"

migrate:
	python $$REPO/manage.py distributed_migrate --noinput
	python $$REPO/manage.py distributed_elasticsearch_migrate

load-fixtures:
	python $$REPO/manage.py < fixtures/users.py

collect-assets:
	python $$REPO/manage.py collectstatic --noinput

run:
	python $$REPO/manage.py runserver 0.0.0.0:$$PORT
