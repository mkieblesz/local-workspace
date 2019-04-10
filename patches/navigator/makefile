clean:
	@echo "clean-stuff"

migrate:
	python app/manage.py migrate
	python app/manage.py build_index

load-fixtures:
	python app/manage.py shell < fixtures/users.py

collect-assets:
	python app/manage.py collectstatic --noinput

test: collect-assets
	# flake8 app --exclude=migrations,.venv
	pycodestyle
	pytest app -v --ignore=node_modules --cov=app --cov-config=.coveragerc --capture=no
	if [ "$$CODECOV_REPO_TOKEN" != "" ]; then \
	   codecov --token=$$CODECOV_REPO_TOKEN ;\
	fi

run:
	python app/manage.py runserver 0.0.0.0:8008
