#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Exiting."
  exit 1
fi

echo "Starting setup for Learning Locker..."

# Step 1: Install Nagios plugins
echo "Installing Nagios plugins..."
apt-get update
apt-get install nagios-plugins-contrib -y

# Step 2: Add .bash_profile for root
echo "Copying .bash_profile..."
cp /root/files/.bash_profile /root/

# Step 3: Disable MongoDB
echo "Disabling MongoDB service..."
systemctl disable mongod.service

# Step 4: Create log directories and set permissions
echo "Creating directories for Learning Locker logs..."
mkdir -p /var/log/learninglocker/xapi_fs/
mkdir -p /var/log/learninglocker/xapi/
mkdir -p /var/log/learninglocker/webapp/
chown -R alertdriving:alertdriving /var/log/learninglocker/

# Step 5: Copy .env files to their respective locations
echo "Copying .env files..."
cp /root/files/xapi/.env /opt/learninglocker/current/xapi/.env
cp /root/files/webapp/.env /opt/learninglocker/current/webapp/.env

# Step 6: Update NGINX configuration
echo "Updating NGINX configuration..."
rm -f /etc/nginx/sites-enabled/default
cp /root/files/learninglocker.conf /etc/nginx/conf.d/

cp /root/files/scaleUpLRS.sh /home/alertdriving/scaleUpLRS.sh
chmod a+x /home/alertdriving/scaleUpLRS.sh
chown alertdriving:alertdriving /home/alertdriving/scaleUpLRS.sh

# Step 7: Reboot the VM


# As alertdriving user
echo "Switching to alertdriving user tasks..."
su - alertdriving <<EOF


(crontab -l 2>/dev/null; echo "00 3 1,15 * * find /opt/learninglocker/current/xapi/storage/accessLogs -iname \"*.log\" -mtime +30 -type f -delete > /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "@reboot /home/alertdriving/scaleUpLRS.sh") | crontab -


EOF


echo "Setup complete!"

echo "Rebooting the VM to finalize setup..."

exit

reboot