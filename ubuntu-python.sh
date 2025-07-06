#!/bin/bash

set -e

# sudo -i // this line is commented because this can be used as aws userdata script which has root privileges by default

# Update system
apt update -y && apt upgrade -y


# Add Docker's official GPG key 

apt update -y
apt install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc


# Add repo to apt sources

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update -y

apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

systemctl enable docker

echo "$(docker --version)" > ~/result.txt

# Install python latest version with requests, prometheus_api_client, openai.

apt update -y && apt upgrade -y
apt install python3 python3-pip -y 
