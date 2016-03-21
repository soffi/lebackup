#!/bin/bash
source $(dirname "$0")/config-vars
# mount backup target
mount $NFSSERVER $BACKUPDIR
#back up files
$(dirname "$0")/lebackup-files.sh
#back up vms
if [ -z "$VMS" ];
then
	echo no vms
	exit 0
fi
for VM in $VMS
	do
		$(dirname "$0")/lebackup-vm.sh $VM
	done

