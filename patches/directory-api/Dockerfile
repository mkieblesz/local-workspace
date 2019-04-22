FROM python:3.6
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY requirements_test.txt /usr/src/app/
COPY new_makefile /usr/src/app/
RUN make -f new_makefile install
# uncomment if you need to run without mounting volume
# COPY . /usr/src/app
CMD ["make", "-f", "new_makefile", "run"]
