## This is to backup data folder into the same S3 bucket.
## Set your bucket name
BUCKET=YOUR-BUCKET-NAME

sudo docker-compose down
sudo aws s3 cp ../../data  s3://$BUCKET/blog-backups --recursive --exclude *.log*
sudo docker-compose up -d