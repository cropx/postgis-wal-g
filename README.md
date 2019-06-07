# postgis-wal-g
Docker image for a PostGIS database with wal-g backup and point-in-time recovery

# Usage
When you instantiate a postgis-wal-g container, pass environment variables for wal-, see https://github.com/wal-g/wal-g.
E.g.

    WALG_FILE_PREFIX=/backups/

or

    WALG_S3_PREFIX=s3://com.mycompany.mysystem.dbbackup/
    AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXX
    AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    AWS_REGION=eu-central-1

