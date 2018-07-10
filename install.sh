#!/bin/bash

$DOMAIN="example.com"

# from https://docs.docker.com/install/linux/docker-ce/ubuntu/

sudo apt-get remove docker docker-engine docker.io

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

# pub   4096R/0EBFCD88 2017-02-22
#      Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
#uid                  Docker Release (CE deb) <docker@docker.com>
#sub   4096R/F273FCD8 2017-02-22

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install docker-ce

# install docker-compose https://docs.docker.com/compose/install/

sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# install certbot https://certbot.eff.org/lets-encrypt/ubuntuxenial-other.html

sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot

# get certificate for domain
mkdir certs
sudo certbot certonly --standalone -d "$DOMAIN"
sudo cat "/etc/letsencrypt/live/$DOMAIN/fullchain.pem"  > certs/domain.crt
sudo cat "/etc/letsencrypt/live/$DOMAIN/privkey.pem" > certs/domain.key

# set password
mkdir auth
docker run \
  --entrypoint htpasswd \
  registry:2 -Bbn testuser testpassword > auth/htpasswd

# run
sudo docker-compose up -d
