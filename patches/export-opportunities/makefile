clean:
	rm -rf tmp/*

install-ruby:
	bundle _1.16.6_ install --local --jobs 4 --path vendor/bundle
	test ! -f config/application.yml && cp config/application.example.yml config/application.yml

install: install-ruby

migrate:
	rake db:migrate

load-fixtures:
	rake db:seed
	rake elasticsearch:import_opportunities
	rake elasticsearch:import_subscriptions
	curl -XPUT "http://es:9200/subscriptions_development/_settings" -d '{ "index" : { "max_result_window" : 500000 } }'
	curl -XPUT "http://es:9200/opportunities_development/_settings" -d '{ "index" : { "max_result_window" : 500000 } }'

run:
	THREADS=2 PROCESSES=2 bundle exec rails server -b 0.0.0.0 -p $(PORT)
