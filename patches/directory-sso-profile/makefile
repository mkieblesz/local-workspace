clean:
	@echo "clean-stuff"

build:
	@echo "Building app images"

load-fixtures:
	python manage.py < fixtures/users.py

collect-assets:
	python manage.py collectstatic --noinput

run:
	python manage.py runserver 0.0.0.0:$$PORT
