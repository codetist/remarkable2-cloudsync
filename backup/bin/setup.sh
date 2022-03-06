#!/bin/sh

# copy service and timer configuration files to systemd directory
cp /home/root/backup/systemd/backup.service /etc/systemd/system/
cp /home/root/backup/systemd/backup.timer /etc/systemd/system/

# make files executable
chmod +x /home/root/backup/bin/backup.sh
chmod +x /home/root/backup/bin/rclone

# enable the service and timer
systemctl daemon-reload
systemctl enable backup.service
systemctl enable backup.timer

# start the timer
systemctl start backup.timer