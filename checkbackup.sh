#!/bin/bash

BUCKET_PATHS=(
	"repo1:bucket1"
	"repo1:bucket2"
	"repo1:bucket3"
	"repo2:bucket"
	"repo3:bucket"
)
DAYS_THRESHOLD=2
MAILFROM="noreply+alert@icc.gg"
MAILTO="recipient@icc.gg"

for bucket in "${BUCKET_PATHS[@]}"; do
	rclone_output=$(rclone lsl "$bucket" --max-age 2d)
	if [ -z "$rclone_output" ]; then
		aws ses send-email --from $MAILFROM --to $MAILTO --text "This $bucket looks outdated in $DAYS_THRESHOLD days or more." --html "<h1>Warning!</h1><p>This $bucket looks outdayed in $DAYS_THRESHOLD days or more.</p>" --subject "❌ $bucket outdated!"
	fi
done
