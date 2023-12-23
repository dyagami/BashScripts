---Backup script by dyagami---
	Usage:
		./backup_script.sh [ -d DIRECTORY | -l LIMIT | -p PATH ]"
			-d DIRECTORY - Directory which will be backed up. [DEFAULT: $HOME]"
			-l LIMIT - Backup limit after which the script will remove the oldest backups. Use with caution. [DEFAULT: user's home folder]"
			-p PATH - Path in which the script will create a backup folder and store backups. [DEFAULT: $HOME/backups]
			-h - view help
