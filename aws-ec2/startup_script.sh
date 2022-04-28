#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
newgrp docker
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
ln -s /usr/bin/aws aws
aws ecr get-login-password --region ap-south-1|docker login --username AWS --password-stdin 213386773652.dkr.ecr.ap-south-1.amazonaws.com
docker pull docker push 213386773652.dkr.ecr.ap-south-1.amazonaws.com/ec2-test:latest
docker run -p 80:3000 213386773652.dkr.ecr.ap-south-1.amazonaws.com/ec2-test:latest
