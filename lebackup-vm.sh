#!/bin/bash
set -x
source $(dirname "$0")/config-vars
VM=$1
if [ -z $1 ];
	then
		echo provide vm name
		exit 1
fi
BLOCKDEVTYPE=$(virsh domblklist $VM|tail -2|head -1|awk '{print $1}')
BLOCKDEV=$(virsh domblklist $VM|tail -2|head -1|awk '{print $2}')

echo creating snapshot
virsh snapshot-create-as --domain $VM $VM-snap --diskspec $BLOCKDEVTYPE,file=$SCRATCHDIR/$VM-snap.qcow2 --disk-only --atomic

echo backing up
rsync -avh --progress $BLOCKDEV $BACKUPDIR/$VM-backup-$(date +"%m-%d-%Y-%H%M").qcow2

echo merging snapshot
virsh blockcommit $VM $BLOCKDEVTYPE --active --verbose --pivot

echo deleting snapshot
virsh snapshot-delete $VM $VM-snap --metadata
rm $SCRATCHDIR/$VM-snap.qcow2

echo finished!
