clean:
	find . -type d -name "__pycache__" -delete

install-python:
	pip install -r requirements_test.txt

install: install-python

migrate:
	python manage.py distributed_migrate --noinput
	python manage.py migrate_translation --noinput

load-fixtures:
	python manage.py shell < fixtures/users.py

load-dbdump:
	@echo "Follow instructions manually"
	# to load landing pages create dump in dev environment
	# $ cf login
	# $ cf ssh directory-cms-dev
	# then on the machine run
	# cf-host$ deps/0/bin/python3.6 app/manage.py dumpdata  --indent 4 > dump.json
	# follow instructions to scp it back to fixtures/dump.json file and remove it from dev environment
	# https://docs.cloudfoundry.org/devguide/deploy-apps/ssh-apps.html#-app-ssh-access-without-cf-cli
	# django's flush command doesn't work so database will have to be recreated manually
	# $ python manage.py loaddata fixtures/dump.json

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
