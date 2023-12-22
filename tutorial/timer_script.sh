#!/bin/bash

usage=$'\nUsage:\ntimer_script.sh -m MINUTES (optional) -s SECONDS\n'
total_seconds=""
while getopts "m:s:b:" opt; do
	case "$opt" in
		m)
		if [[ "$OPTARG" == *[!0-9]* ]]; then	
			echo "$OPTARG is not a number!"
			exit 1
		else
			total_seconds=$(( $total_seconds + ($OPTARG * 60) ))
		fi;;
		s) 
		if [[ "$OPTARG" == *[!0-9]* ]]; then
			echo "$OPTARG is not a number!"
			exit 1
		else	
			total_seconds=$(( $total_seconds + $OPTARG ))
		fi;;
		\?) echo "$usage"; exit 1;;
	esac
done

if [ $# -eq 0 ]; then
	echo "$usage"
	exit 1
else
	echo "Timer has started! $total_seconds seconds left"
	while [[ $total_seconds -gt 0 ]]; do
		echo "$total_seconds seconds left"
		sleep 1
		total_seconds=$(( $total_seconds - 1 ))
done
fi
echo "Time's Up!"
