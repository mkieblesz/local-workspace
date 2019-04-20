FROM python:3.6
RUN wget --quiet -O - https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y nodejs
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY requirements_test.txt /usr/src/app/
COPY package.json /usr/src/app/
COPY new_makefile /usr/src/app/
RUN make -f new_makefile install
COPY . /usr/src/app
CMD ["make", "-f", "new_makefile", "run"]
