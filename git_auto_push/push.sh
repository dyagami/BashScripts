#!/bin/bash

for i in $( ls ); do
	if [[ -d $i  ]] && [[ $i != '.' ]] && [[ $i != '..' ]] ; then
		cd $i
		while [[ -z $(git status | grep "Your Branch is ahead" ]] || [[ -z $(git status | grep "Changes not staged") ]]; do
			if [[ -z $(git status | grep "Your Branch is ahead") ]] ; then
				echo "$i: pushing commits"
				git push
			fi
			if [[ -z $(git status | grep "Changes not staged") ]] ; then
				echo "$i: staging and committing"
				git add . ; git commit -m "auto-generated commit"
			fi
		done
		cd $OLDPWD
	fi
done
#Your branch is ahead
#Changes not staged
