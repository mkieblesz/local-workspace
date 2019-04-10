FROM ruby:2.5.1
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
COPY vendor /usr/src/app
RUN gem install bundler -v 1.16.6 && bundle _1.16.6_ install
COPY . /usr/src/app
CMD ["make", "-f", "new_makefile", "run"]
