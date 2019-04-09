clean:
	@echo "clean-stuff"

build:
	@echo "Building app images"

migrate:
	python manage.py distributed_migrate --noinput

load-fixtures:
	python manage.py shell < $$REPO_PATCH/fixtures/users.py
	python manage.py shell < $$REPO_PATCH/fixtures/api_clients.py

collect-assets:
	python manage.py collectstatic --noinput

run:
	python manage.py runserver 0.0.0.0:$$PORT
