#!/usr/bin/env bash

# wal-g expects postgres vars PGXXXX, but postgres Docker image uses POSTGRES_XXXX.
export PGUSER=$POSTGRES_USER
export PGDATABASE=$POSTGRES_DB
export PGPORT=$POSTGRES_PORT
export PGPASSWORD=$POSTGRES_PASSWORD
wal-g "$@"