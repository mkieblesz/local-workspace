clean:
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete

build:
	@echo "Building app images"

migrate:
	python manage.py distributed_migrate --noinput
	python manage.py migrate_translation --noinput

load-fixtures:
	python manage.py shell < fixtures/users.py

collect-assets:
	python manage.py collectstatic --noinput

lint-python:
	flake8 --config=new_setup.cfg

lint: lint-python

test-python: collect-assets
	pytest -v --ignore=venv --ignore=conf/celery.py --cov=. --reuse-db --capture=no

test: test-python

test-all: lint test

ci-test-all: test-all
	@echo "Run pipeline test suite"
	codecov --token=$$CODECOV_REPO_TOKEN

run:
	python manage.py runserver 0.0.0.0:$$PORT

run-proxy-links:
	PROXY_LINKS=true python manage.py runserver 0.0.0.0:$$PORT
