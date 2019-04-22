FROM ruby:2.5.5
RUN wget --quiet -O - https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y nodejs
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN gem install bundler -v 1.16.6

# copy files first to optimize build
COPY Gemfile /usr/src/app/
RUN mkdir -p vendor/cache
COPY vendor/cache/* /usr/src/app/vendor/cache/
RUN mkdir -p config
COPY config/application.example.yml config/application.yml
COPY new_makefile /usr/src/app/

# instead of vendor/bundle install globally
RUN bundle _1.16.6_ install --local --jobs 4

# uncomment if you need to run without mounting volume
# COPY . /usr/src/app
CMD ["make", "-f", "new_makefile", "run"]
