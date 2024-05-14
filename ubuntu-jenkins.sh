# Use this script on Userdata field on while launching an EC2 Instance on AWS or on startup script field while launching a VM on GCP

#!/bin/bash

# Switch to superuser (root) interactive mode for executing subsequent commands with elevated privileges
sudo -i

# Update the list of available packages from the repositories by accepting all the prompts with yes (-y)
apt update -y

# Install the fontconfig and openjdk-17-jre packages, necessary dependencies for Jenkins, by accepting all the prompts with yes (-y)
apt install fontconfig openjdk-17-jre -y

# Download the Jenkins repository key and save it to '/usr/share/keyrings/jenkins-keyring.asc'.
wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add the Jenkins repository to the system's list of package sources, specifying the key location and repository URL.
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update the list of available packages from the repositories by accepting all the prompts with yes (-y)
apt-get update -y

# Install Jenkins package, by accepting all the prompts with yes (-y)
apt-get install jenkins -y

# Check the status of the Jenkins service.
systemctl status jenkins

# Start the Jenkins service.
systemctl start jenkins
