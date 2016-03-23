#!/bin/bash
set -e
source $(dirname "$0")/config-vars
# mount and create backup target 
#mkdir -p $BACKUPDIR
#mount $NFSSERVER $BACKUPDIR
#back up files
$(dirname "$0")/lebackup-files.sh
#back up vms
if [ -z "$VMS" ];
then
	echo no vms
	#umount $BACKUPDIR
	rm -Rf $BACKUPDIR
	exit 0
fi
for VM in $VMS
	do
		$(dirname "$0")/lebackup-vm.sh $VM
	done
# remove and unmout backupdir
#umount $BACKUPDIR
#rm -Rf $BACKUPDIR
