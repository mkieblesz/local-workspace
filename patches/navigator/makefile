clean:
	find . -type d -name __pycache__ | xargs rm -rf

install-python:
	pip install -r requirements_test.txt

install-js:
	npm install

install: install-python install-js

migrate:
	python app/manage.py migrate
	python app/manage.py build_index

load-fixtures:
	python app/manage.py shell < fixtures/users.py

compile-assets:
	npm run build

collect-assets:
	python app/manage.py collectstatic --noinput

lint-python:
	pycodestyle --config=new_setup.cfg
	flake8 app --config=new_setup.cfg

lint-js:
	@echo "Linting javascript"

lint: lint-python lint-js

test-python: collect-assets
	pytest app -v --cov=app --capture=no

test-js:
	@echo "Testing javascript"

test: test-python test-js

test-all: lint test

ci-test-all: test-all
	@echo "Run pipeline test suite"
	codecov --token=$(CODECOV_REPO_TOKEN)

run:
	python app/manage.py runserver 0.0.0.0:$(PORT)
