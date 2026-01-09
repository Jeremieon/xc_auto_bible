#!/bin/bash
set -e

apt-get update -y
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

sleep 30

docker run -d -p 8080:80 --restart always jeremy9k/foodwmagic:v0.1
docker run -d -p 3000:3000 --restart always bkimminich/juice-shop
docker run -d --name frontend-app --restart always -p 8000:8000 \
  -e BACKEND_URL=http://azure.backend.internal \
  jeremy9k/aws:v1.0.0
