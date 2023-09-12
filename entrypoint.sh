#!/bin/bash
echo "Sawasdee Krub Thailand NO.1"
gunicorn --worker-class eventlet -w 4 -b :56730 wsgi:app
