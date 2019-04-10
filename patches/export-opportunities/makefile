clean:
	@echo "clean-stuff"

build:
	@echo "Building app images"

migrate:
	rake db:migrate

load-fixtures:
	rake db:seed
	rake elasticsearch:import_opportunities
	rake elasticsearch:import_subscriptions
	curl -XPUT "http://0.0.0.0:9200/subscriptions_development/_settings" -d '{ "index" : { "max_result_window" : 500000 } }'
	curl -XPUT "http://0.0.0.0:9200/opportunities_development/_settings" -d '{ "index" : { "max_result_window" : 500000 } }'

run:
	THREADS=2 PROCESSES=2 bundle exec rails server -b 0.0.0.0 -p $$PORT
