# postgis-wal-g
Docker image for a PostGIS database with wal-g backup and point-in-time recovery

# Usage
When you instantiate a postgis-wal-g container, pass environment variables for wal-g, see the documentation:
https://github.com/wal-g/wal-g.

E.g.

    WALG_S3_PREFIX=s3://com.mycompany.mysystem.dbbackup/
    AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXX
    AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    AWS_REGION=eu-central-1

or
    WALG_FILE_PREFIX=/backups/

If you use WALG_FILE_PREFIX, you should make sure the specified directory is backed up to external storage, to
make sure you can recover the backup in case the database server is lost.

You can pass the wal-g env variables to the `docker run` command when you instantiate your container.
Or you can put the variables in an env-file and pass a reference to that env-file to docker or docker-compose.
The env-file option allows you to keep your secret external storage keys only on the deployment server in a 
convenient way.

Instantiation using Docker: e.g.
    docker run \
    --name my-db-container \
    --env-file wal-g.env

Instantiation using Docker-compose: e.g.
    service postgis

# Scheduling full backup
You need an external scheduler that periodically invokes the backup command on the PostGIS container.
This could be e.g. Unix/Linux cron. Your crontab entry then should be like this:
    0 1 * * * /usr/bin/docker exec -i my-db-container backup.sh >> /var/log/my-postgis-backup.log

# Point-in-time recovery (PITR)

## PITR with docker-compose
Use this sequence of steps if your postgis-wal-g container is managed by docker-compose. 

It is assumed that you have one postgis-wal-g container running, and you can start/stop it with 
`docker-compose start [my-postgis-container]` / `docker-compose stop [my-postgis-container]`

- Stop any client application of your postgis container.
- start a bash command line on the server where your postgis container runs.
- `cd` to the directory where your docker-compose.yml resides.
- set a variable with your postgis container name:\
  `export CONTAINER=[my-postgis-container]`\
  E.g. `export CONTAINER=postgis`
- stop the postgis container:\
  `docker-compose stop $CONTAINER`
- copy your current data files, just in case you need them later on, if you have enough disk space left:\
  `docker-compose run --rm -v "/var/postgis-data-copy:/data-copy" $CONTAINER sh -c 'cp -Rp $PGDATA /data-copy'`
- delete all from the postgres data directory. It must be empty for recovery:\ 
  `docker-compose run --rm $CONTAINER sh -c 'rm -rf $PGDATA/*'` 
- list your backups:\
  `docker-compose run --rm $CONTAINER wal-g backup-list` 
- This gives a list of backups, e.g.\
```
name                          last_modified             wal_segment_backup_start
base_000000010000000400000052 2019-06-11T01:07:18+02:00 000000010000000400000052
base_000000010000000400000082 2019-06-12T01:07:51+02:00 000000010000000400000082
base_000000010000000400000085 2019-06-13T01:07:59+02:00 000000010000000400000085
```
- Recover the desired backup. This may take a while. E.g. recovery of a 1GB backup may take 5 minutes.\ 
  `docker-compose run --rm $CONTAINER sh -c 'wal-g-script.sh backup-fetch $PGDATA base_000000010000000400000085'`
- determine the timestamp that you want to recover to, in the format `2019-06-13 10:45:00+02` 
- Create a postgres recovery config file. Replace the timestamp with your timestamp:
```
docker-compose run --rm  $CONTAINER sh -c "
cat <<EOF > /var/lib/postgresql/data/recovery.conf
restore_command = 'wal-g-script.sh wal-fetch %f %p'
standby_mode = off
recovery_target_action = 'promote'
recovery_target_time = '2019-06-13 10:45:00+02'
recovery_target_timeline = latest
EOF"
```
- start the recovery:\
  `docker-compose run --rm $CONTAINER postgres`
- start the postgis container:\
  `docker-compose start $CONTAINER`
- Start your application