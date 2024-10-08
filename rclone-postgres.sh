#!/bin/bash

FILENAMEDATE=$(date +%Y-%m-%dT%H-%M-%S)      # date-time format to be used on files
DATABASE=db-name                             # database name
USER=db-username-or-db-root                  # db username with read access
RCLONEREMOTE=rclone-remote-name              # rclone remote name
BUCKET=bucket-name                           # rclone remote name
WEBDIR1=/path1/of/webdir/before/webfolder    # path previous to planned for backup
# WEBDIR2=/path2/of/webdir/before/webfolder  # use it if you have more than 1 webdir to backup
WEBFOLDER1=htdocs-or-equivalent              # path previous to planned for backup
# WEBFOLDER2=htdocs-or-equivalent            # use it if you have more than 1 webfolder to backup
RETENTION=7d                                 # retention required before delete file
# PGPASSWORD=db-user-password                # uncomment and update with Postgres password if needed

mkdir -p ./backup

# Edit accordly for MariaDB backup. You can also use for MySQL backup just changing dump application. Comment of you do not need it.
# /opt/bitnami/mariadb/bin/mariadb-dump --defaults-extra-file=./.dbpassword.cnf -u $USER --single-transaction --skip-lock-tables --quick $DATABASE > ./backup/$FILENAMEDATE.sql
mariadb-dump --defaults-extra-file=./.dbpassword.cnf -u $USER --single-transaction --skip-lock-tables --quick $DATABASE > ./backup/$FILENAMEDATE.sql

# Ucomment and edit accordly for Postgres backup.
# export PGPASSWORD=$PGPASSWORD
# pg_dump -h 127.0.0.1 -U $USER $DATABASE > ./backup/$FILENAMEDATE.sql

tar -czf ./backup/$FILENAMEDATE-DB.tar.gz --remove-files ./backup/$FILENAMEDATE.sql
tar -zcf ./backup/$FILENAMEDATE-$WEBFOLDER1.tar.gz --exclude=*.tar.gz -C $WEBDIR1 $WEBFOLDER1
# tar -zcf ./backup/$FILENAMEDATE-$WEBFOLDER2.tar.gz --exclude=*.tar.gz -C $WEBDIR2 $WEBFOLDER2

rclone move ./backup/$FILENAMEDATE-DB.tar.gz $RCLONEREMOTE:$BUCKET/
rclone move ./backup/$FILENAMEDATE-$WEBFOLDER1.tar.gz $RCLONEREMOTE:$BUCKET/
# rclone move ./backup/$FILENAMEDATE-$WEBFOLDER2.tar.gz $RCLONEREMOTE:$BUCKET/
rclone delete --min-age $RETENTION $RCLONEREMOTE:$BUCKET/ --b2-hard-delete
