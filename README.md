# Deploy Ghost blog in AWS using CloudFormation

Ghost is a lightweight blogging platform. This repository contains CloudFormation scripts and other resources 
to deploy your own Ghost blog stack in AWS. 

The stack runs 4 docker containers inside an EC2 instance.
  1. Ghost -  blogging platform
  2. Traefik - reverse proxy
  3. Commento - commenting platform
  4. PostgreSQL - commento database 

Docker-compose is used for the container orchestration.

Below is the high level design. 

![blog-design](diagrams/aws-ghost-hosting.png)

## Prerequisites
1. Registered domain for the Lets Encrypt integration to work
2. User account and domain verification with an SMTP provider such as mailgun
3. AWS account and an IAM user with programmatic access

## Configuration files to update before deployment
Once you clone the repository make sure to update the following files to reflect your details.

1. commento.env

   Comment out everything but below two values for the initial deployment as smtp setup 
   interferes with the Commento admin account registration
   
   * `COMMENTO_ORIGIN`
   
   * `COMMENTO_POSTGRES`

2. ghost.env - add your smtp details here
3. docker-compose.yaml
   
   Update the following lines
    
   * `certificatesresolvers.letsencrypt.acme.email={YOUR EMAIL}`
   * `traefik.http.routers.ghost.rule=Host({YOUR DOMAIN})`
   * `traefik.http.routers.commento.rule=Host(commento.{YOUR DOMAIN})`

4. ghost-blog-setup.cfn.yaml

   * `command: "sudo aws s3 cp s3://{YOUR BUCKET NAME}/blog/config/ /data/traefik/ --recursive"`

5. inception.cfn.yaml
   
   * Update `HostedZone` with your domain
   * Update `MyMailGunDomainKeyRecordSet` resource with your domain key

6. Makefile
   
   * Update `REGION`, `PROFILE` and `BUCKET` values


## Initial deployment
1. Deploy the `inception stack` - this creates the initial infrastructure in the AWS account
    - `make create-inception-stack STACK_NAME=inception-stack-name`
2. Deploy the `blog-host stack` - this deployes and configures the Ghost host
    - `make create-blog-host-stack STACK_NAME=host-stack-name` 

Check CloudFormation stacks for any errors.

## After deployment
1. Use AWS SSM to log into the Ghost host, navigate to /data/traefik folder and bring up the stack with `docker-compose up -d`
2. Register your admin user with ghost on https://yourdomain.com/ghost
3. Register yourself to the local commento on https://commento.yourdomain.com
4. Use AWS SSM to log into the Ghost host, navigate to /data/traefik folder and bring down the stack with `docker-compose down`
5. Uncomment smtp setup values in `commento.env`
6. Uncomment `COMMENTO_FORBID_NEW_OWNERS=true` to avoid new registered users 
6. Bring up the stack again with `docker-compose up -d`

## How to backup the blog configs and content
1. In the Ghost host: `cd /data/traefik`
2. Set `BUCKET` value in `backup-all.sh`
3. `./backup-all.sh`

This will backup all the content and config files into the S3. 

## How to update all the components
1. In the Ghost host: `cd /data/traefik`
2. Set `BUCKET` value in `update-components.sh`
3. `./update-components.sh`

This will pull new docker images and update the stack.

## Further info
Have a look at https://fewmorewords.com/ghost-on-aws 

It explains everything in detail.

## Demo blog

The fully working demo site is available on https://jayforweb.com

## Reference
1. https://ghost.org/
2. https://containo.us/traefik/
3. https://commento.io/


Enjoy!
