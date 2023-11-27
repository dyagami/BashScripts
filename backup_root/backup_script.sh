#!/bin/bash

clear

# This script backups desired directory into backup partition

# Declare variables
# $backuppath can be any folder or parition, there will be created a "backups" folder there,
# in which the backups will reside
# If backing up root partition, run with sudo

backuppath="/rootbackups"
pathtobackup="/"
filepath="$backuppath/backups/backup_$(date +%m-%d-%y_%H:%M:%S).tar.gz" 
backuplimit=3
redcolor="\e[31m"
nocolor="\e[0m"

# Check if backups folder exists. If not, create one

if [ ! -d $backuppath/backups ] ; then
	mkdir $backuppath/backups
	echo -e "No backup folder present in $redcolor$backuppath$nocolor, creating one..."
fi

# Countdown

echo -e "Script will now back up ${redcolor}${pathtobackup}${nocolor}. \"CTRL-C\" to cancel."
echo -e "File path: $redcolor$filepath$nocolor"
echo "---Backup starting in---"
sleep 1
for i in {5..1}
do
	echo -e "$recolor$i...$nocolor"
	sleep 1
done

# Archive and compress root filesystem

clear

touch $filepath
sudo tar --exclude-ignore-recursive=$backuppath/backups/* -czvf $filepath $pathtobackup 1> /dev/null 


# Declare filecount variable after checking for backup folder

filecount="$( ls $backuppath/backups | sort | wc -l )"


echo -e "Current backup count: $redcolor$filecount$nocolor"

# Check if there's more than $backuplimit backups and delete the oldest ones to not exceed it

if [ $filecount -gt $(($backuplimit-1)) ] ; then
	echo -e "Backups exceeded the limit of $redcolor$backuplimit$nocolor. \nWill now delete the oldest ones to not exceed limit... \n${redcolor}DONE.${nocolor}"

else
	echo -e "Will remove the oldest backup if the count goes up to: ${redcolor}${backuplimit}${nocolor}\n"
fi
while [ $filecount -gt $backuplimit ]; do	
	rm $backuppath/backups/$(ls $backuppath/backups | sort | head -1)
	filecount=$(($filecount-1))
done
echo -e "Backup count after deletion: $redcolor$filecount$nocolor"
echo -e "${redcolor}DONE${nocolor}"
