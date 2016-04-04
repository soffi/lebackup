#!/bin/bash
source $(dirname "$0")/config-vars
STARTTIME=$(date +"%m-%d-%Y-%H%M")
mkdir -p $SCRATCHDIR
tar cvf $SCRATCHDIR/$(hostname)-filebackup-$STARTTIME.tar $(cat $(dirname "$0")/backup-files.list)
rsync -avh --no-o --no-g --progress $SCRATCHDIR/$(hostname)-filebackup-$STARTTIME.tar $RSYNCSERVER
rm $SCRATCHDIR/$(hostname)-filebackup-$STARTTIME.tar
