clean:
	@echo "clean-stuff"

build:
	@echo "Building app images"

migrate:
	python manage.py migrate

load-fixtures:
	python manage.py < fixtures/users.py
	python manage.py < fixtures/sso_clients.py

run:
	python manage.py runserver 0.0.0.0:8004
