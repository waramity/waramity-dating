#! /usr/bin/env sh

echo "Running inside /app/prestart.sh, you could add migrations to this file, e.g.:"

echo "
#! /usr/bin/env bash

# Let the DB start
sleep 10;
# Run migrations
alembic upgrade head
"

gunicorn --worker-class eventlet -w 4 -b :56730 wsgi:app
