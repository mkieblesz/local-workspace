clean:
	@echo "clean-stuff"

build:
	@echo "Building app images"

load-fixtures:
	python manage.py < fixtures/users.py
	python manage.py < fixtures/sso_clients.py

collect-assets:
	python manage.py collectstatic --noinput

run:
	python manage.py runserver 0.0.0.0:8007
