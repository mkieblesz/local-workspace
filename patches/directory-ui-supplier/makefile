clean:
	find . -type d -name __pycache__ | xargs rm -rf

install-python:
	pip install -r requirements_test.txt

install: install-python

collect-assets:
	python manage.py collectstatic --noinput

run:
	python manage.py runserver 0.0.0.0:$(PORT)
