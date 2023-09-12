#!/bin/bash
gunicorn --worker-class eventlet -w 4 --bind 143.198.206.234:56730 wsgi:app
# gunicorn --worker-class eventlet -w 4 --bind 0.0.0.0:8000 wsgi:app
# uwsgi --http :56730 --gevent 1000 --http-websockets --master --wsgi-file wsgi.py --callable app
