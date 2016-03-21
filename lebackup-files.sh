tar cvjf $(hostname)-backup-$(date +"%m-%d-%Y-%H%M").tar.bz2 $(cat backuplist.txt)
