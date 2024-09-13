#!/bin/bash

FILENAMEDATE=$(date +%Y-%m-%dT%H-%M-%S)
DATABASE=db-name
USER=db-user
RCLONEREMOTE=rclone-remote-name
BUCKET=bucket-name
WEBDIR=/path1/of/webdir/before/webfolder
WEBDIR2=/path2/of/webdir/before/webfolder
WEBFOLDER1=htdocs-or-equivalent
WEBFOLDER2=htdocs-or-equivalent
RETENTION=7d
PGPASSWORD=db-user-password

mkdir -p ./backup

export PGPASSWORD=$PGPASSWORD
pg_dump -h 127.0.0.1 -U $USER $DATABASE > ./backup/$FILENAMEDATE.sql

tar -czf ./backup/$FILENAMEDATE-DB.tar.gz --remove-files ./backup/$FILENAMEDATE.sql
tar -zcf ./backup/$FILENAMEDATE-$WEBFOLDER1.tar.gz --exclude=*.tar.gz -C $WEBDIR1 $WEBFOLDER1
tar -zcf ./backup/$FILENAMEDATE-$WEBFOLDER2.tar.gz --exclude=*.tar.gz -C $WEBDIR2 $WEBFOLDER2

rclone move ./backup/$FILENAMEDATE-DB.tar.gz $RCLONEREMOTE:$BUCKET/
rclone move ./backup/$FILENAMEDATE-$WEBFOLDER1.tar.gz $RCLONEREMOTE:$BUCKET/
rclone move ./backup/$FILENAMEDATE-$WEBFOLDER2.tar.gz $RCLONEREMOTE:$BUCKET/
rclone delete --min-age $RETENTION $RCLONEREMOTE:$BUCKET/ --b2-hard-delete
