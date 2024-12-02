#!/bin/bash

# Set non-interactive mode for apt
export DEBIAN_FRONTEND=noninteractive

# Update and clean up
sudo apt-get update -y
sudo apt-get clean -y
sudo apt-get autoremove -y

# Fix broken installations
sudo apt --fix-broken install -y
sudo apt-get update -y && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt-get install -y gnupg2
sudo apt-get update -y
# Install specific OpenSSL package
wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb
sudo apt-get update -y
# Set up MongoDB repository
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
# Install MongoDB
sudo apt-get update -y
sudo apt-get update -y
sudo apt-get install -f -y mongodb-org

sudo systemctl enable mongod
sudo systemctl restart mongod

# Install Redis
sudo apt install -y redis-server

# Install Python 2.7.18 on Debian 12
sudo apt update -y
sudo apt install -y build-essential zlib1g-dev libssl-dev libreadline-dev libffi-dev wget
wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
tar -xvf Python-2.7.18.tgz
cd Python-2.7.18
./configure --enable-optimizations
make install
python2 --version
cd

# Cleanup
rm -f libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb
rm -rf Python-2.7.18 Python-2.7.18.tgz

# Create user 'alertdriving' and set permissions
sudo useradd -m alertdriving
sudo chmod 755 /home/alertdriving
sudo chsh -s /bin/bash alertdriving


################### Run at the last of installation #############

# Create user 'nginx' with restricted shell
sudo useradd -m nginx
cat /etc/group | grep nginx
cat /etc/passwd | grep nginx
sudo chsh -s /bin/false nginx
cat /etc/passwd | grep nginx

#######################################################

# Install Git
sudo apt install -y git

# Install Node.js v10.24.1 and associated tools
sudo apt-get purge -y node*
cd /tmp/
wget https://nodejs.org/dist/v10.24.1/node-v10.24.1-linux-x64.tar.gz
tar zxvf node-v10.24.1-linux-x64.tar.gz
sudo cp -r node-v10.24.1-linux-x64/{bin,include,lib,share} /usr/
sudo npm install -g pm2
sudo npm install -g yarn
sudo apt-mark hold nodejs
cd

# Cleanup Node.js installation files
rm -f /tmp/node-v10.24.1-linux-x64.tar.gz
rm -rf /tmp/node-v10.24.1-linux-x64




# Display versions and test Redis
echo "================== Versions and Tests =================="
echo "MongoDB Version:"
mongod --version
echo "Python Version:"
python2 --version
echo "Redis CLI Ping Test:"
redis-cli ping
echo "Node.js Version:"
node -v
echo "npm Version:"
npm -v
echo "========================================================"

echo "Script execution completed!"