clean:
	find . -type d -name "__pycache__" -delete

install-python:
	pip install -r requirements_test.txt

install: install-python

lint-python:
	flake8 --config=new_setup.cfg

lint: lint-python

test-python:
	pytest --ignore=.venv --ignore=node_modules --cov=. --capture=no

test: test-python

test-all: lint test

ci-test-all: test-all
	codecov --token=$(CODECOV_REPO_TOKEN)

run:
	python manage.py runserver 0.0.0.0:$(PORT)
