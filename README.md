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
The env-file option allows you to keep your secret external storage keys only on the deployment server in a convenient way.

Instantiation using Docker: e.g.
    docker run \
    --name my-db-container \
    --env-file wal-g.env

Instantiation using Docker-compose: e.g.
    service postgis

# Scheduling full backup
You need an external scheduler that periodically invokes the backup command on the PostGIS container.
This could be e.g. Unix/Linux cron. Your crontab entry then should be like this:
    0 1 * * * docker exec my-db-container backup.sh >> /var/log/my-postgis-backup.log

# Point-in-time recovery (PITR)

- start a bash command line on the server where your postgis container runs.
- for convenience, set a variable with your container name: `export CONTAINER=[my-postgis-container]
- stop the database container: `docker stop $CONTAINER` or `docker-compose stop $CONTAINER` or ...
- copy your current data files, just in case, if you have enough disk space left:
  `docker run --rm $CONTAINER sh -c 'cp -Rp $PGDATA/data $PGDATA/data-bk'`
TODO finish