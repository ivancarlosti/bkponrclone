#!/bin/bash

BUCKET_PATHS=(
	"repo1:bucket1"
	"repo1:bucket2"
	"repo1:bucket3"
	"repo2:bucket"
	"repo3:outrobucket"
)
DAYS_THRESHOLD=2
MAILFROM="remetente@pad.vg"
MAILTO="destinatario@pad.vg"

for bucket in "${BUCKET_PATHS[@]}"; do
	rclone_output=$(rclone lsl "$bucket" --max-age 2d)
	if [ -z "$rclone_output" ]; then
		aws ses send-email --from $MAILFROM --to $MAILTO --text "O $bucket parece estar desatualizado em $DAYS_THRESHOLD dias ou mais." --html "<h1>Atenção!</h1><p>O $bucket parece estar desatualizado em $DAYS_THRESHOLD dias ou mais.</p>" --subject "❌ $bucket sem atualização!"
	fi
done
