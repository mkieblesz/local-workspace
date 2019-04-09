clean:
	@echo "clean-stuff"

build:
	@echo "Building app images"

migrate:
	python manage.py distributed_migrate --noinput
	python manage.py migrate_translation --noinput

load-fixtures:
	python manage.py shell < $$REPO_PATCH/fixtures/users.py

collect-assets:
	python manage.py collectstatic --noinput

run:
	python manage.py runserver 0.0.0.0:$$PORT
