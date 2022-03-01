# remarkable2-cloudsync
***
## Purpose

A small script, allowing you to sync your Remarkable 2 documents to the cloud or a local server automatically.

## What the script does

* Preconditions to save battery life (as a sync, especially encrypted, is an expensive operation on a Remarkable 2 device)...
  * Check for internet connectivity (by sending a single ping to  ```google.com```)
  * Check if there were any changes to your Remarkable files since last sync
* If preconditions are satisfied, sync your files from the Remarkable 2 to the target location (one direction only)

## Requirements

This script requires 
[Rclone](https://github.com/rclone/rclone), a free command line program to manage files on cloud storage.
It supports a wide variety of protocols and cloud providers. A full list is available 
[here](https://rclone.org/overview/).

## Setup

### Copy files and folders to your Remarkable 2

The directory layout is expected to look as follows. If you change it, don't forget to modify 
the ```backup.sh``` and ```backup.service``` files accordingly.

* /home/root/backup
  * bin
    * backup.sh
    * rclone (binary)
  * conf
    * rclone.conf (rclone config file)
  * log
  * systemd
    * backup.service
    * backup.timer

### Rclone

[Download](https://rclone.org/downloads/) the ```rclone``` binary and place it in the ```/home/root/backup/bin``` 
directory. Make sure you download the ARM(v7)-32bit version.

Create a [Rclone configuration](https://rclone.org/docs/) for your desired cloud or target server. The expected default
name of your config is ```cloud```. If you use another name, change the ```backup.sh``` script accordingly.

To create your config interactively, simply run and follow the instructions:

```
rclone config
```

When finished a config file is created for you. To find its location run:

```
rclone config file
```

Move or copy this file to ```/home/root/backup/conf``` or change the ```backup.sh``` file, to point to the correct 
location.

### Configuration

#### backup.sh

Files and directories can be changed in the ```backup.sh``` file.
Change them as required.

```
# Remarkable data (notes, pdf documents etc)
RMDATA="/home/root/.local/share/remarkable/xochitl"
# Home directory of the backup tool
BACKUPPATH="/home/root/backup"
# Path to the rclone.conf
CONFPATH="$BACKUPPATH/conf"
# Path to rclone binary
BINPATH="$BACKUPPATH/bin/rclone"
# Path to log directory
LOGPATH="$BACKUPPATH/log"
# Name and path of sync file, indicating the date and time of last successful sync operation
SYNCFILE="$LOGPATH/lastSync.txt"
```

### Configure backup.timer

To modify how often your backup is run, modify the ```backup.timer``` script. As the default, the backup script will
be run one minute after the device has been started and every 5 minutes afterwards. No syncs will take place, when
the device is in sleep mode.

```
OnBootSec=1min
OnUnitInactiveSec=5min
```

### Install backup service

Execute the following commands on your Remarkable 2:

```
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
```

Rerun ```systemctl daemon-reload``` whenever you change
the ```/etc/systemd/system/backup.timer```file!

### Remarkable 2 Official Updates

⚠️ User-defined services are getting removed by system updates. ⚠️
So the steps under [Install backup services](#install-backup-service) might need to be executed again after updating your Remarkable 2!

### What's next?

Some ideas, what to do with the synced data:

* Restore your data to a new Remarkable.
* Create point-in-time backups and restore as needed.
* Use a tool like [RCU](http://www.davisr.me/projects/rcu/), to convert the proprietary file format to PDF
  automatically. Making your notes accessible for other devices.
* ...
