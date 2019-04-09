clean:
	@echo "clean-stuff"

migrate:
	python $$REPO/app/manage.py migrate
	python $$REPO/app/manage.py build_index

load-fixtures:
	python $$REPO/app/manage.py < fixtures/users.py

collect-assets:
	python $$REPO/app/manage.py collectstatic --noinput

test: collect-assets
	# flake8 app --exclude=migrations,.venv
	pycodestyle
	pytest ./$$REPO/app -v --ignore=node_modules --cov=./$$REPO/app --cov-config=.coveragerc --capture=no
	if [ "$$CODECOV_REPO_TOKEN" != "" ]; then \
	   codecov --token=$$CODECOV_REPO_TOKEN ;\
	fi

run:
	python $$REPO/app/manage.py runserver 0.0.0.0:$$PORT
