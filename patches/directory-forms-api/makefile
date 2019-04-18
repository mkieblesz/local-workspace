clean:
	find . -type d -name "__pycache__" -delete

install-python:
	pip install -r requirements_test.txt

install: install-python

migrate:
	python manage.py distributed_migrate --noinput

load-fixtures:
	python manage.py shell < fixtures/users.py
	python manage.py shell < fixtures/api_clients.py

collect-assets:
	python manage.py collectstatic --noinput

lint-python:
	flake8 --config=new_setup.cfg

lint: lint-python

test-python: collect-assets
	pytest . --cov=. --capture=no

test: test-python

test-all: lint test

ci-test-all: test-all
	codecov --token=$(CODECOV_REPO_TOKEN)

run:
	python manage.py runserver 0.0.0.0:$(PORT)
