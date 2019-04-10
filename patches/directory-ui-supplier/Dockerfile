FROM python:3.6
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY requirements_test.txt /usr/src/app/
RUN pip install -r requirements_test.txt
COPY . /usr/src/app
CMD ["make", "-f", "new_makefile", "run"]
