clean:
	find . -type d -name "__pycache__" -delete

build:
	@echo "Building app images"

install-python:
	pip install -r requirements_test.txt

install: install-python

load-fixtures:
	python manage.py < fixtures/users.py
	python manage.py < fixtures/sso_clients.py

run:
	python manage.py runserver 0.0.0.0:$$PORT
