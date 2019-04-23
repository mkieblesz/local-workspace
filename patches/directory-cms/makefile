clean:
	find . -type d -name __pycache__ | xargs rm -rf

install-python:
	pip install -r requirements_test.txt

install: install-python

migrate:
	python manage.py distributed_migrate --noinput
	python manage.py migrate_translation --noinput

load-fixtures:
	./scripts/load_fixtures.sh
	python manage.py shell < fixtures/users.py

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
	codecov --token=$(CODECOV_REPO_TOKEN)

run:
	python manage.py runserver 0.0.0.0:$(PORT)

run-celery:
	celery -A conf worker -l info
