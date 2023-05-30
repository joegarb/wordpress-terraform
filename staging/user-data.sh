#!/bin/bash

# Install docker and docker-compose
sudo yum update -y
sudo yum install docker -y
sudo usermod -a -G docker ec2-user
sudo mkdir -p /usr/local/lib/docker/cli-plugins/
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
sudo service docker start
sudo chkconfig docker on

cd /home/ec2-user
docker compose up -d
