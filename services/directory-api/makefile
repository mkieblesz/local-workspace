clean:
	@echo "clean-stuff"

build:
	@echo "Building app images"

migrate:
	python manage.py distributed_migrate --noinput
	python manage.py distributed_elasticsearch_migrate

load-fixtures:
	python manage.py < $$REPO_PATCH/fixtures/users.py

collect-assets:
	python manage.py collectstatic --noinput

run:
	python manage.py runserver 0.0.0.0:8000
