#!/bin/sh

host="postgres"

until PGPASSWORD=$(cat /run/secrets/db_password) psql -h $host -U $(cat /run/secrets/db_username) -c '\q' ifttt; do
  >&2 echo "DB unavailable - sleeping"
  sleep 1
done

>&2 echo "DB up - execute"

if test $MIGRATION = true; then
  python3 manage.py makemigrations backend --no-input --settings=backend.settings.prod
  python3 manage.py migrate --no-input --settings=backend.settings.prod
  python3 manage.py initadmin --settings=backend.settings.prod
fi

# python3 manage.py collectstatic --no-input
exec python3 manage.py runserver 0.0.0.0:8000 --settings=backend.settings.prod
