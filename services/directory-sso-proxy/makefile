clean:
	@echo "clean-stuff"

build:
	@echo "Building app images"

load-fixtures:
	python manage.py < fixtures/users.py
	python manage.py < fixtures/sso_clients.py

run:
	python manage.py runserver 0.0.0.0:$$PORT
