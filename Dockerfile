# Windows
# FROM python:3.10.7-alpine

# MacOS
# FROM python:3.10.7-slim

# WORKDIR /waramity-portfolio
# COPY . /waramity-portfolio
# COPY requirements.txt .
# RUN pip install -r requirements.txt
# COPY . .

# M1 cannot use port 5000
# EXPOSE 5001
# CMD ["python", "wsgi.py", "--host=0.0.0.0"]
# CMD ["flask", "run", "--host=0.0.0.0", "--port=5001"]

# FROM tiangolo/uwsgi-nginx:python3.10
# RUN apk --update add bash nano
# ENV STATIC_URL /static
# ENV STATIC_PATH /var/www/app/static
# COPY requirements.txt /var/www/requirements.txt
# RUN pip install -r /var/www/requirements.txt

# FROM python:3.6.8-alpine3.9

FROM python:3.10.7-alpine

ENV GROUP_ID=1000 \
    USER_ID=1000

WORKDIR /var/www/

ADD . /var/www/

ENV STATIC_URL /static
ENV STATIC_PATH /var/www/app/static
COPY requirements.txt /var/www/requirements.txt

# RUN pip install -r requirements.txt

RUN pip install -r /var/www/requirements.txt
RUN pip install gunicorn

# Add user for flask application
RUN addgroup -g $GROUP_ID www
RUN adduser -D -u $USER_ID -G www www -s /bin/sh

# Change current user to www
USER www

EXPOSE 5000

CMD [ "gunicorn", "-w", "4", "--bind", "0.0.0.0:5000", "wsgi"]
