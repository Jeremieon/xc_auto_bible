#!/bin/bash
set -e

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

# Deploy vulnerable applications
sudo docker run -d -p 8080:80 jeremy9k/foodwmagic:v0.1
sudo docker run -d -p 8081:3000 bkimminich/juice-shop

# -------------------------------------------------------------------
# Nginx test container (robust for EC2 user data)
# -------------------------------------------------------------------

# Wait for Docker daemon to be ready
until docker info >/dev/null 2>&1; do
  sleep 2
done

# Create web root
mkdir -p /opt/nginx-html
echo "<h1>This container is up</h1>" > /opt/nginx-html/index.html

# Remove container if it already exists (AMI reuse / reboot safety)
docker rm -f nginx-test || true

# Run Nginx
docker run -d \
  -p 8000:80 \
  -v /opt/nginx-html:/usr/share/nginx/html:ro \
  --name nginx-test \
  nginx:latest
