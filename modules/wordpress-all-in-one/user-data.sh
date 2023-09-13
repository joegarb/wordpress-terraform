#!/bin/bash

# Set initial IP in Route 53
sh /var/lib/cloud/scripts/per-boot/update-ip.sh

# Install docker and docker-compose
sudo yum update -y
sudo yum install docker -y
sudo usermod -a -G docker ec2-user
sudo mkdir -p /usr/local/lib/docker/cli-plugins/
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
sudo service docker start
sudo chkconfig docker on

# Support using private docker images from ECR (along with IAM resources attached to the instance)
sudo dnf install -y amazon-ecr-credential-helper
mkdir /home/ec2-user/.docker
cat << EOF > /home/ec2-user/.docker/config.json
{
	"credsStore": "ecr-login"
}
EOF

cd /home/ec2-user
docker --config /home/ec2-user/.docker compose up -d
