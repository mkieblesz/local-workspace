clean:
	find . -type d -name "__pycache__" -delete

install-python:
	pip install -r requirements_test.txt

install: install-python

migrate:
	# run migration up to LAST_MIGRATION_NAME, if not set it will run all
	# used to load fixtures
	python manage.py distributed_migrate --noinput $$LAST_MIGRATION_NAME
	python manage.py migrate_translation --noinput $$LAST_MIGRATION_NAME

load-fixtures:
	python manage.py shell < fixtures/users.py

load-dbdump:
	@echo "Follow instructions in 'scripts/db_dump.sh' script"


collect-assets:
	python manage.py collectstatic --noinput

lint-python:
	flake8 --config=new_setup.cfg

lint: lint-python

test-python: collect-assets
	# pytest -v --ignore=.venv --ignore=conf/celery.py --cov=. --reuse-db --capture=no
	pytest -v --ignore=.venv --ignore=conf/celery.py --cov=. --capture=no

test: test-python

test-all: lint test

ci-test-all: test-all
	codecov --token=$$CODECOV_REPO_TOKEN

run:
	python manage.py runserver 0.0.0.0:$$PORT
