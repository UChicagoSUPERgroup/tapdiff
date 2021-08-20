#!/bin/sh

host="postgres"

until PGPASSWORD="password" psql -h $host -U "iftttuser" -c '\q' ifttt; do
  >&2 echo "DB unavailable - sleeping"
  sleep 1
done

>&2 echo "DB up - execute"

if test $MIGRATION = true; then
  python3 manage.py makemigrations backend --no-input --settings=backend.settings.debug
  python3 manage.py migrate --no-input --settings=backend.settings.debug
  python3 manage.py initadmin --settings=backend.settings.debug
fi

# python3 manage.py collectstatic --no-input
exec python3 manage.py runserver 0.0.0.0:8000 --settings=backend.settings.debug
