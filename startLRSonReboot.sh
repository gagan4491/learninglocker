#!/bin/bash

LOGFILE="/root/reboot_script.log"
echo "Starting script at $(date)" | tee -a $LOGFILE
su - alertdriving -c "pm2 stop all" >> $LOGFILE 2>&1
rm -rf /home/alertdriving/.pm2 >> $LOGFILE 2>&1
su - alertdriving -c "cd /opt/learninglocker/current/webapp && pm2 start all.json" >> $LOGFILE 2>&1
su - alertdriving -c "cd /opt/learninglocker/current/xapi && pm2 start xapi.json" >> $LOGFILE 2>&1
sleep 5
su - alertdriving -c "pm2 status" >> $LOGFILE 2>&1
echo "Script finished at $(date)" | tee -a $LOGFILE
exit 0
