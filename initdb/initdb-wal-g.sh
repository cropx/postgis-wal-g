#!/bin/bash
if grep -q "wal-g" "/var/lib/postgresql/data/postgresql.conf"; then
    echo "wal-g already configured in /var/lib/postgresql/data/postgresql.conf"
else
    # wal-g env settings are of form WALE_* or WALG_*
    if ! env | -q grep -e '^WALG_' -e '^WALE_'; then
        echo "No wal-g env variables WALG_* or WALE_* found, WAL file archiving is DISABLED!"
    else
        echo "adding wal-g archive settings to /var/lib/postgresql/data/postgresql.conf"
        echo "wal_level = archive" >> /var/lib/postgresql/data/postgresql.conf
        echo "archive_mode = on" >> /var/lib/postgresql/data/postgresql.conf
        echo "archive_command = 'wal-g wal-push %p'" >> /var/lib/postgresql/data/postgresql.conf
        echo "archive_timeout = 60" >> /var/lib/postgresql/data/postgresql.conf
    fi
fi

