#!/usr/bin/env bash
# delete backups older than retention period
if [ -z "${BACKUP_RETAIN_NUMBER}" ]
then
  echo "ERROR: BACKUP_RETAIN_NUMBER not set. Not cleaning up any older backups. Current list of backups:"
  wal-g-script.sh backup-list
  exit 1
else
  wal-g-script.sh delete retain FULL ${BACKUP_RETAIN_NUMBER} --confirm
fi
