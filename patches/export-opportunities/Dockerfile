FROM ruby:2.5.5
RUN wget --quiet -O - https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y nodejs
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
COPY vendor /usr/src/app
RUN mkdir -p /usr/src/app/config
COPY config/application.example.yml /usr/src/app/config
COPY new_makefile /usr/src/app/
RUN make -f new_makefile install
COPY . /usr/src/app
CMD ["make", "-f", "new_makefile", "run"]
