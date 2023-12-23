#!/bin/bash

read -r -p "What folder you want to cruft from?: " folder
read -r -p "How many days old files to cruft have to be?: " time

readarray -t filelist < <(find -type f -mtime "$time")
for i in "${filelist[@]}"; do
	echo "$i"
	# rm -i "$i"
done
