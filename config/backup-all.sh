#!/bin/bash
## This is to backup data folder into the same S3 bucket.
## Set your bucket name
set -euo pipefail

BUCKET=YOUR-BUCKET-NAME
cd /data/traefik
sudo docker-compose down
cd /data
sudo zip -r -q fmw-backup.zip .
sudo aws s3 cp fmw-backup.zip s3://$BUCKET/blog-backups/archives/
sudo rm fmw-backup.zip
cd /data/traefik
sudo docker-compose up -d