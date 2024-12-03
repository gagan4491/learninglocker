#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Exiting."
  exit 1
fi


echo "Disabling NGINX ."
systemctl disable nginx.service
service nginx stop

echo "Switching to alertdriving "
su - alertdriving <<EOF
pm2 stop all
pm2 save

echo "Commenting out crontab for alertdriving user..."
crontab -l | sed '/.*/s/^/#/' | crontab -
EOF

echo " NGINX disabled, and PM2 processes stopped."


