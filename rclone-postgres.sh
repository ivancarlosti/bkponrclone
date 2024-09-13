#!/bin/bash

FILENAMEDATE=$(date +%Y-%m-%dT%H-%M-%S)
DATABASE=dspace
USER=dspace
BUCKET=publicacoes-dspace
WEBDIR1=/opt/
WEBDIR2=/var/solr/data/
WEBFOLDER1=dspace
WEBFOLDER2=userfiles
RETENTION=7d
PGPASSWORD=dspace

mkdir -p ./backup

export PGPASSWORD=$PGPASSWORD
pg_dump -h 127.0.0.1 -U $USER $DATABASE > ./backup/$FILENAMEDATE.sql

tar -czf ./backup/$FILENAMEDATE-DB.tar.gz --remove-files ./backup/$FILENAMEDATE.sql
tar -zcf ./backup/$FILENAMEDATE-$WEBFOLDER1.tar.gz --exclude=*.tar.gz -C $WEBDIR1 $WEBFOLDER1
tar -zcf ./backup/$FILENAMEDATE-$WEBFOLDER2.tar.gz --exclude=*.tar.gz -C $WEBDIR2 $WEBFOLDER2

rclone move ./backup/$FILENAMEDATE-DB.tar.gz remote:$BUCKET/
rclone move ./backup/$FILENAMEDATE-$WEBFOLDER1.tar.gz remote:$BUCKET/
rclone move ./backup/$FILENAMEDATE-$WEBFOLDER2.tar.gz remote:$BUCKET/
rclone delete --min-age $RETENTION remote:$BUCKET/ --b2-hard-delete


