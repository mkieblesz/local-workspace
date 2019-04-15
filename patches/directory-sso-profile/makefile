clean:
	find . -type d -name "__pycache__" -delete

build:
	@echo "Building app images"

install-python:
	pip install -r requirements_test.txt

install-js:
	npm install

install: install-python install-js

compile-assets:
	./node_modules/.bin/gulp sass

collect-assets:
	python manage.py collectstatic --noinput

lint-python:
	flake8 --config=new_setup.cfg

lint: lint-python

test-python: collect-assets
	pytest --ignore=.venv --ignore=node_modules --cov=. --capture=no

test: test-python

test-all: lint test

ci-test-all: test-all
	codecov --token=$$CODECOV_REPO_TOKEN

run:
	python manage.py runserver 0.0.0.0:$$PORT

run-proxy-links:
	PROXY_LINKS=true python manage.py runserver 0.0.0.0:$$PORT
