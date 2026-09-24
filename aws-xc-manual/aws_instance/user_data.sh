#!/bin/bash
set -e

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release git

# Install Docker
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Ensure SSH server exists and is running
sudo apt-get install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

# Deploy vulnerable applications
sudo mkdir -p /usr/local/lib/docker/cli-plugins 
sudo curl -SL https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose 
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
sudo docker pull bkimminich/juice-shop:latest
sudo docker run --restart unless-stopped -d -p 3000:3000 bkimminich/juice-shop:latest
sudo docker run --restart unless-stopped -d -p 3020:80 jeremy9k/foodwmagic:v0.1
sudo docker run --restart unless-stopped -d -p 3010:8000 jeremy9k/tanto:v01
cd /home/ubuntu
git clone https://github.com/Jeremieon/lb_testing_xc.git
chown -R ubuntu:ubuntu lb_testing_xc
cd lb_testing_xc
sudo docker compose up -d