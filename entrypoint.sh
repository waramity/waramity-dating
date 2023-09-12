#!/bin/bash
gunicorn --worker-class eventlet -w 4 --bind 143.198.206.234:56730 wsgi:app
