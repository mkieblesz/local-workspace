clean:
	find . -type d -name "__pycache__" -delete

install-python:
	pip install -r requirements_test.txt

install-js:
	npm install

install: install-python install-js

collect-assets:
	python manage.py collectstatic --noinput

run:
	python manage.py runserver 0.0.0.0:$$PORT
