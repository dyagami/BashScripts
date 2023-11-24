#!/bin/bash

# This script backups whole root filesystem into backup partition

# Declare variables
# $backuppath can be any folder or parition, there will be created a "backups" folder there,
# in which the backups will reside
backuppath="."
filepath="$backuppath/backups/backup_$(date +%m-%d-%y_%H:%M).tar.gz" 
backuplimit=7
redcolor="\e[31m"
nocolor="\e[0m"

# Check if backups folder exists. If not, create one
if [ ! -d $backuppath/backups ] ; then
	mkdir $backuppath/backups
	echo -e "No backup folder present in $redcolor$backuppath$nocolor, creating one..."
fi

# Declare filecount variable after checking for backup folder
filecount="$( ls $backuppath/backups | sort | wc -l )"

# Countdown
echo "Script will now back up root filesystem. \"CTRL-C\" to cancel."
echo -e "File path: $redcolor$filepath$nocolor"
echo "---Backup starting in---"
sleep 1
for i in {5..1}
do
	echo -e "$recolor$i...$nocolor"
	sleep 1
done

# Archive and compress root filesystem
tar -czvf $filepath / --exclude-ignore-recursive=$backuppath/backups
clear

echo -e "Current backup count: $redcolor$filecount$nocolor"

# Check if there's more than $backuplimit backups and delete the oldest one if true
if [ $filecount -gt $(($backuplimit-1)) ] ; then
	echo -e "Backups exceeded the limit of $redcolor$backuplimit$nocolor. \nWill now delete the oldest one"
# Will add while loop here to delete all backups above the limit
	rm $(ls $backuppath/backups | sort | sed "|\$backuplimit q|;d")
else
	echo -e "Will remove the oldest backup if the count goes up to: $redcolor$backuplimit$nocolor"
fi

