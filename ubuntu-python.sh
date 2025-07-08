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

# Not yet tested the below 
export NODE_EXPORTER_VERSION=node_exporter-1.9.1.linux-amd64
wget https://github.com/prometheus/node_exporter/releases/download/v1.9.1/$NODE_EXPORTER_VERSION.tar.gz

# create a dedicated user and group
sudo groupadd -f node_exporter
sudo useradd -g node_exporter --no-create-home --shell /bin/false node_exporter
sudo mkdir /etc/node_exporter
sudo chown node_exporter:node_exporter /etc/node_exporter

# extract the tar files

tar -xvf node_exporter-1.0.1.linux-amd64.tar.gz
mv node_exporter-1.0.1.linux-amd64 node_exporter-files

# Copy node_exporter binary from node_exporter-files folder to /usr/bin and change the ownership to prometheus user.
sudo cp node_exporter-files/node_exporter /usr/bin/
sudo chown node_exporter:node_exporter /usr/bin/node_exporter

# Create a node_exporter service file.

sudo vi /usr/lib/systemd/system/node_exporter.service

Add the following content:

[Unit]
Description=Node Exporter
Documentation=https://prometheus.io/docs/guides/node-exporter/
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
ExecStart=/usr/bin/node_exporter \
  --web.listen-address=:9100

[Install]
WantedBy=multi-user.target

sudo chmod 664 /usr/lib/systemd/system/node_exporter.service

# restart the systemd service to register the prometheus service and start the prometheus service.

sudo systemctl daemon-reload
sudo systemctl start node_exporter

# check the status

sudo systemctl status node_exporter

# enable the service 
sudo systemctl enable node_exporter.service

Reference: https://developer.couchbase.com/tutorial-node-exporter-setup/
