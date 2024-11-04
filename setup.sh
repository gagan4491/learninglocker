#!/bin/bash

# Update package list and install necessary packages
apt-get update && apt-get upgrade
 apt install -y sudo curl wget python build-essential xvfb apt-transport-https

# Install Git
echo "Installing Git..."
sudo apt install git -y
git --version

# Install GCC Toolchain
echo "Installing GCC Toolchain..."
sudo apt install build-essential -y
gcc --version

# Install Node.js (v16) and Yarn
echo "Installing Node.js v16..."
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v
npm -v

echo "Installing Yarn..."
npm install --global yarn

yarn -v
sleep 10

# Install MongoDB (v4+) from Percona
echo "Installing MongoDB..."
wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
sudo apt update
sudo percona-release enable psmdb-40 release
sudo apt update
sudo apt install -y percona-server-mongodb

# Start and enable MongoDB service
sudo systemctl start mongod
sudo systemctl enable mongod

# Install Redis (v2.8.18+)
echo "Installing Redis..."
sudo apt install redis-server -y
sudo sed -i 's/supervised no/supervised systemd/' /etc/redis/redis.conf
sudo systemctl restart redis.service
sudo systemctl enable redis-server.service
redis-cli ping

# Install Nginx
echo "Installing Nginx..."
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

# Install PM2 for process management
echo "Installing PM2..."
npm install pm2@latest -g
pm2 startup
pm2 save

# Instructions for using PM2
echo "To start your application with PM2, use: pm2 start app.js"

# Install Supervisor for process management (optional alternative to PM2)
# Uncomment the following lines if you want to install Supervisor as well.
# echo "Installing Supervisor..."
# sudo apt-get install supervisor -y
# echo "To configure Supervisor, create a config file at /etc/supervisor/conf.d/your_app.conf"
# echo "Add the necessary configuration and then run:"
# echo "sudo supervisorctl reread"
# echo "sudo supervisorctl update"
# echo "sudo supervisorctl start your_app"
