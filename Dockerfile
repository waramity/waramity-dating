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

#############################################################################################

# FROM tiangolo/uwsgi-nginx:python3.10
# RUN apk --update add bash nano
# ENV STATIC_URL /static
# ENV STATIC_PATH /var/www/app/static
# COPY requirements.txt /var/www/requirements.txt
# RUN pip install -r /var/www/requirements.txt

# FROM python:3.6.8-alpine3.9

#############################################################################################

FROM python:3.10.7-alpine

ENV GROUP_ID=1000 \
    USER_ID=1000

WORKDIR /var/www/

# Remove default configuration from Nginx
# RUN rm /etc/nginx/conf.d/default.conf

# Install Supervisord
# RUN apt-get update && apt-get install -y supervisor \
&& rm -rf /var/lib/apt/lists/*

# ADD . /var/www/

# ENV STATIC_URL /static
ENV STATIC_PATH /var/www/app/static
COPY requirements.txt /var/www/requirements.txt

# RUN pip install -r requirements.txt

RUN pip install -r /var/www/requirements.txt
RUN pip install gunicorn
# RUN pip install gevent


# Add user for flask application
RUN addgroup -g $GROUP_ID www
RUN adduser -D -u $USER_ID -G www www -s /bin/sh

# RUN groupadd -g 1000 www
# RUN useradd -u 1000 -ms /bin/bash -g www www


COPY . /var/www
# RUN chown -R www:www /var/www/
COPY --chown=www:www . /var/www


# Change current user to www
USER www

# EXPOSE 443

# CMD [ "gunicorn", "--worker-class", "eventlet", "-w", "4", "--bind", "0.0.0.0:443", "wsgi:app"]

EXPOSE 56730

# RUN ["chmod", "+x", "./entrypoint.sh"]

# ENTRYPOINT ["./entrypoint.sh"]

CMD [ "gunicorn", "--worker-class", "eventlet", "-w", "4", "--bind", "0.0.0.0:56730", "wsgi:app"]
