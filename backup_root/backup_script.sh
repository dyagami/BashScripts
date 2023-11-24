#!/bin/bash

clear
# This script backups desired directory into backup partition

# Declare variables
# $backuppath can be any folder or parition, there will be created a "backups" folder there,
# in which the backups will reside
backuppath="."
pathtobackup="/home/lain"
filepath="$backuppath/backups/backup_$(date +%m-%d-%y_%H:%M).tar.gz" 
backuplimit=7
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
touch $filepath
tar --exclude-ignore-recursive=$backuppath/backups -czvf $filepath $pathtobackup
clear

# Declare filecount variable after checking for backup folder
filecount="$( ls $backuppath/backups | sort | wc -l )"


echo -e "Current backup count: $redcolor$filecount$nocolor"

# Check if there's more than $backuplimit backups and delete the oldest one if true
if [ $filecount -gt $(($backuplimit-1)) ] ; then
	echo -e "Backups exceeded the limit of $redcolor$backuplimit$nocolor. \nWill now delete the oldest one... \n${redcolor}DONE.${nocolor}"
# Will add while loop here to delete all backups above the limit
	rm $backuppath/backups/$(ls $backuppath/backups | sort | head -1)
else
	echo -e "Will remove the oldest backup if the count goes up to: ${redcolor}${backuplimit}${nocolor}\n${redcolor}DONE${nocolor}"
fi

