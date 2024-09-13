#!/bin/bash

FILENAMEDATE=$(date +%Y-%m-%dT%H-%M-%S)
DATABASE=db-name
USER=db-username-or-db-root
RCLONEREMOTE=rclone-remote-name
BUCKET=bucket-name
WEBDIR=/path/of-web-dir-before-webfolder
WEBFOLDER=htdocs-or-equivalent
RETENTION=7d

mkdir -p ./backup

mariadb-dump --defaults-extra-file=./.dbpassword.cnf -u $USER --single-transaction --skip-lock-tables --quick $DATABASE > ./backup/$FILENAMEDATE.sql

tar -czf ./backup/$FILENAMEDATE-DB.tar.gz --remove-files ./backup/$FILENAMEDATE.sql
tar -czf ./backup/$FILENAMEDATE-WEB.tar.gz -C $WEBDIR $WEBFOLDER

rclone move ./backup/$FILENAMEDATE-DB.tar.gz $RCLONEREMOTE:$BUCKET/
rclone move ./backup/$FILENAMEDATE-WEB.tar.gz $RCLONEREMOTE:$BUCKET/
rclone delete --min-age $RETENTION $RCLONEREMOTE:$BUCKET/


