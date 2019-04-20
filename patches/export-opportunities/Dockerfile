FROM ruby:2.5.5
RUN wget --quiet -O - https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y nodejs
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN gem install bundler -v 1.16.6
# copy files first to optimize build
COPY Gemfile* /usr/src/app/
RUN mkdir -p vendor
COPY vendor/cache /usr/src/app/vendor/
RUN mkdir -p config
COPY config/application.example.yml /usr/src/app/config/
COPY new_makefile /usr/src/app/

RUN make -f new_makefile install
COPY . /usr/src/app
CMD ["make", "-f", "new_makefile", "run"]
