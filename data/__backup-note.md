# Data backup
1. run the docker. 
2. in another terminal, run this to save database *ifttt* into file outside docker named  *file-name.sql*. 
   ```sh
   docker exec -i -t iot-fullstack_postgres_1 pg_dump --clean ifttt > backup.sql
   ```
   - *iot-fullstack_postgres_1* is the container name. Check it using ```docker ps```

# Data restore
1. run the docker.
2. go to the backup sql file's directory.
3. copy the backup file into docker.
   ```sh
   docker cp ./backup.sql iot-fullstack_postgres_1:/home/postgres/backup.sql
   ```
4. enter the container and change file permission.
   ```sh
   docker exec -i -t --user root diffstack_postgres_1 /bin/bash
   chown postgres /home/postgres/backup.sql
   ```
5. reset data.
   ```sh
   su - postgres
   psql ifttt -U postgres < /home/postgres/backup.sql
   ```