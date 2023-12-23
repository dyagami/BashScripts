#!/bin/bash


# This script backups desired directory into backup partition

# Declare variables
# $backuppath can be any folder or parition, there will be created a "backups" folder there,
# in which the backups will reside
# If backing up root partition, run with sudo

backuppath="$HOME"
pathtobackup="$HOME"
backuplimit=3
redcolor="\e[31m"
nocolor="\e[0m"

# Get options for backup directory, backup path and backup limit

while getopts "d:l:p:h" opt; do
	case "$opt" in
		d)
			pathtobackup="$OPTARG"
			if [[ ! -d "$OPTARG" ]]; then
				echo -e "${redcolor}$OPTARG folder doesn't exist! Cannot backup non-existent folder. Exiting..."
			exit 1
			fi
			;;
		l)
			backuplimit="$OPTARG"
			if [[ ! "$OPTARG" == [0-9] ]]; then
				echo -e "${redcolor}$OPTARG is not a number. Backup limit specified must be a number! Exiting..."
			exit 1
			fi
			;;
		p)
			backuppath="$OPTARG" 
			[[ -d "$OPTARG" ]] || mkdir "$OPTARG" ;;
		h)
			echo "---Backup script by dyagami---"
			echo "Usage:"
			echo "		./backup_script.sh [ -d DIRECTORY | -l LIMIT | -p PATH ]"
			echo "	-d DIRECTORY - Directory which will be backed up. [DEFAULT: $HOME]"
			echo "	-l LIMIT - Backup limit after which the script will remove the oldest backups. Use with caution. [DEFAULT: $backuplimit]"
			echo "	-p PATH - Path in which the script will create a backup folder and store backups. [DEFAULT: $backuppath/backups]"
			echo "	-h - view this help page."
			exit 0
			;;
		\?)
			echo "$OPTARG is not a valid option. Exiting..."
			exit 1
	esac
done

clear

filepath="$backuppath/backups/backup_$(date +%m-%d-%y_%H:%M:%S).tar.gz" 

# Check if backups folder exists. If not, create one

if [ ! -d "$backuppath/backups" ] ; then
	mkdir "$backuppath/backups"
	echo -e "No backup folder present in $redcolor$backuppath$nocolor, creating one..."
fi

# Countdown

echo -e "Script will now back up ${redcolor}${pathtobackup}${nocolor}. \"CTRL-C\" to cancel."
echo -e "File path: $redcolor$filepath$nocolor"
echo "---Backup starting in---"
sleep 1
for i in {5..1}
do
	echo -e "$redcolor$i...$nocolor"
	sleep 1
done

# Archive and compress root filesystem

clear

touch "$filepath"
tar --exclude-ignore-recursive="$backuppath/backups/*" -czvf "$filepath" "$pathtobackup" 1> /dev/null 

echo -e "File created"
echo -e "File path: ${redcolor}$filepath${nocolor}"
echo -e "Size: ${redcolor}$(ls -lah "$filepath" | cut -d" " -f5)${nocolor}"

# Declare filecount variable after checking for backup folder

filecount="$( ls "$backuppath/backups/" | sort | wc -l )"


echo -e "Current backup count: $redcolor$filecount$nocolor"

# Check if there's more than $backuplimit backups and delete the oldest ones to not exceed it

if [ "$filecount" -gt $(($backuplimit-1)) ] ; then
	echo -e "Backups exceeded the limit of $redcolor$backuplimit$nocolor. \nWill now delete the oldest ones to not exceed limit... "

else
	echo -e "Will remove the oldest backup if the count goes up to: ${redcolor}${backuplimit}${nocolor}\n"
fi
while [ "$filecount" -gt "$backuplimit" ]; do	
	rm "$backuppath/backups/$(ls "$backuppath/backups" | sort | head -1)"
	filecount=$(($filecount-1))
done
echo -e "Backup count: $redcolor$filecount$nocolor"
echo -e "${redcolor}DONE${nocolor}"
