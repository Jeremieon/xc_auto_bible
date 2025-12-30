#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Docker
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Ensure SSH server exists and is running
sudo apt-get install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

#Jump
#ssh -i ~/.ssh/id_rsa -J ubuntu@54.147.60.46 ubuntu@10.0.2.71

# Nginx test container
sudo mkdir -p /home/ubuntu/nginx-html
echo "<h1>This container is up</h1>" | sudo tee /home/ubuntu/nginx-html/index.html
sudo docker run -d -p 8000:80 \
  -v /home/ubuntu/nginx-html:/usr/share/nginx/html \
  --name nginx-test nginx:latest
