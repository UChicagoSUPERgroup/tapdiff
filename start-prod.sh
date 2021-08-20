#!/bin/bash

filename="./data/diff.sql"
insertdata=false
migration=false

while [ "$1" != "" ]; do
    case $1 in
        --data)         shift
                        filename=$1
                        insertdata=true
                        ;;
        --init)         insertdata=true
                        migration=true
                        ;;
    esac
    shift
done

mkdir secrets
echo "$(python3 json_parser.py -f settings.json backend_admin_name)" > secrets/backend_admin_name
echo "$(python3 json_parser.py -f settings.json backend_admin_email)" > secrets/backend_admin_email
echo "$(python3 json_parser.py -f settings.json backend_admin_password)" > secrets/backend_admin_password
echo "$(python3 json_parser.py -f settings.json db_username)" > secrets/db_username
echo "$(python3 json_parser.py -f settings.json db_password)" > secrets/db_password
echo "$(python3 json_parser.py -f settings.json backend_django_secret)" > secrets/backend_django_secret
echo "$(python3 json_parser.py -f settings.json host_domain)" > secrets/host_domain

chmod -R a+r ./secrets/

# give permission to write log
chmod g+w,o+w ./data-userlog

sed -e "s/\$host_name/$(python3 json_parser.py -f settings.json host_domain)/" ./templates/environment.prod.ts.template > ./ifttt-frontend/rule-creation/RMI/src/environments/environment.prod.ts
sed -e "s/\$host_name/$(python3 json_parser.py -f settings.json host_domain)/" ./templates/environment.ts.template > ./ifttt-frontend/rule-creation/RMI/src/environments/environment.ts
sed -e "s/\$domain/$(python3 json_parser.py -f settings.json host_domain)/" ./templates/nginx.conf.template > ./nginx/nginx.conf

DATAFILE=$filename docker-compose build

if [ "$insertdata" == true ]; then
    docker-compose down -v
    docker-compose up -d postgres
    docker-compose exec postgres sh /home/postgres/init-db.sh
fi

MIGRATION=$migration docker-compose up
