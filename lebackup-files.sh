#!/bin/bash
source $(dirname "$0")/config-vars
tar cvjf $BACKUPDIR/$(hostname)-filebackup-$(date +"%m-%d-%Y-%H%M").tar.bz2 $(cat $(dirname "$0")/backup-files.list)
