#!/bin/bash

FILENAMEDATE=$(date +%Y-%m-%dT%H-%M-%S)
DATABASE=nomedoseubancodedados
USER=root
RCLONEREMOTE=nomedoseuremote
BUCKET=nomedoseubucket
WEBDIR=/opt/bitnami/apache
WEBFOLDER=htdocs
RETENTION=7d

mkdir -p ./backup

/opt/bitnami/mariadb/bin/mariadb-dump --defaults-extra-file=./.dbpassword.cnf -u $USER --single-transaction --skip-lock-tables --quick $DATABASE > ./backup/$FILENAMEDATE.sql

tar -czf ./backup/$FILENAMEDATE-DB.tar.gz --remove-files ./backup/$FILENAMEDATE.sql
tar -czf ./backup/$FILENAMEDATE-WEB.tar.gz -C $WEBDIR $WEBFOLDER

rclone move ./backup/$FILENAMEDATE-DB.tar.gz $RCLONEREMOTE:$BUCKET/
rclone move ./backup/$FILENAMEDATE-WEB.tar.gz $RCLONEREMOTE:$BUCKET/
rclone delete --min-age $RETENTION $RCLONEREMOTE:$BUCKET/
