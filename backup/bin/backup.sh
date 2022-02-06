#!/bin/sh

# Remarkable data (notes, documents etc)
RMDATA="/home/root/.local/share/remarkable/xochitl"
# Home directory of the backup tool
BACKUPPATH="/home/root/backup"
# Path to the rclone.conf
CONFPATH="$BACKUPPATH/conf"
# Path to rclone binary
BINPATH="$BACKUPPATH/bin/rclone"
# Path to log
LOGPATH="$BACKUPPATH/log"
# Name and path of sync file, indication the date and time of last successful sync operation
SYNCFILE="$LOGPATH/lastSync.txt"

# check for network
if ping -q -c 1 -W 1 google.com >/dev/null 2>&1; then

  # create sync file if it does not exist
  test -f $SYNCFILE || touch -t 200001010100 $SYNCFILE

  # check for files changed since last sync
  FILESCHANGED=$(find $RMDATA -type f -newer $SYNCFILE | wc -l)
  if (($FILESCHANGED > 0 )); then

    echo "$FILESCHANGED files changed, syncing...."

    # Delete previous log
    rm $LOGPATH/lastSync.txt

    # Sync Remarkable data
    /home/root/backup/bin/rclone sync --config=$CONFPATH/rclone.conf --log-file=$SYNCFILE --log-level INFO  $RMDATA cloud:/TabletContent

    # Sync log file
    /home/root/backup/bin/rclone sync --config=$CONFPATH/rclone.conf --ignore-times $SYNCFILE cloud:/
  else
    echo "No files changes..."
  fi

else
  echo "No network..."
fi
