## This will backup site content, pull new docker images and start the site
## after cleaning up the old images

## Set your bucket name
BUCKET=YOUR-BUCKET-NAME

sudo docker-compose down
sudo aws s3 cp ../../data  s3://$BUCKET/blog-backups --recursive --exclude *.log*
sudo docker-compose pull
sudo docker-compose up -d --remove-orphans
sudo docker image prune