#!/bin/bash
if grep -q "wal-g" "/var/lib/postgresql/data/postgresql.conf"; then
    echo "wal-g already configured in /var/lib/postgresql/data/postgresql.conf"
else
    echo "adding wal-g archive settings to /var/lib/postgresql/data/postgresql.conf"
    echo "wal_level = archive" >> /var/lib/postgresql/data/postgresql.conf
    echo "archive_mode = on" >> /var/lib/postgresql/data/postgresql.conf
    echo "archive_command = 'wal-g wal-push %p'" >> /var/lib/postgresql/data/postgresql.conf
    echo "archive_timeout = 60" >> /var/lib/postgresql/data/postgresql.conf
fi

