#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be root."
  exit 1
fi

# Nagios plugins

apt-get update
apt-get install nagios-plugins-contrib -y


echo "Copying .bash_profile..."
cp /root/files/.bash_profile /root/

echo "Disabling MongoDB service..."
systemctl disable mongod.service

echo "Creating directories for Learning Locker logs..."
mkdir -p /var/log/learninglocker/xapi_fs/
mkdir -p /var/log/learninglocker/xapi/
mkdir -p /var/log/learninglocker/webapp/
chown -R alertdriving:alertdriving /var/log/learninglocker/

echo "Copying .env files..."
cp /root/files/xapi/.env /opt/learninglocker/current/xapi/.env
cp /root/files/webapp/.env /opt/learninglocker/current/webapp/.env

echo "Updating NGINX configuration..."
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-available/default
cp /root/files/learninglocker.conf /etc/nginx/conf.d/
cp /root/files/nginx.conf /etc/nginx/

cp /root/files/scaleUpLRS.sh /home/alertdriving/scaleUpLRS.sh
chmod a+x /home/alertdriving/scaleUpLRS.sh
chown alertdriving:alertdriving /home/alertdriving/scaleUpLRS.sh



echo "Switching to alertdriving user tasks..."
su - alertdriving <<EOF


(crontab -l 2>/dev/null; echo "00 3 1,15 * * find /opt/learninglocker/current/xapi/storage/accessLogs -iname \"*.log\" -mtime +30 -type f -delete > /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "@reboot /home/alertdriving/scaleUpLRS.sh") | crontab -


EOF


echo "Setup complete!"

echo "Rebooting the VM to finalize setup..."

reboot

