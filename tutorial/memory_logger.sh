#!/bin/bash

outputdir=$HOME/performance

if ! [[ -d $HOME/performance ]]; then
	echo "Folder $outputdir doesn't exist, creating one..."
	mkdir $HOME/performance
else
	echo "Folder $outputdir exists!"
fi
date +"%m/%d/%y %H:%M:%S" >> $outputdir/memory.log 
free >> $outputdir/memory.log
echo "Last 5 logs:"
tail -n 20 $outputdir/memory.log
