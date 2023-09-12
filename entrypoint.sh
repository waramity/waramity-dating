#!/bin/bash
gunicorn --worker-class eventlet -w 4 -b :56730 wsgi:app
