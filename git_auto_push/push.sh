#!/bin/bash

BLUE='\033[0;34m'
GREEN='\033[1;32m'
NC='\033[0m'
clear

for i in $( ls ); do

#check current directory for subdirectories and check if they are git repos
	if [[ -d $i && "$i" != '.' && "$i" != '..' && -d $i/.git ]] ; then
		echo -e "checking: ${BLUE}$i${NC}"
		cd $i

#check for git statuses other than the repo being up-to-date with remote origin
		while [[ -n $(git status | grep "Your branch is ahead") || -n $(git status | grep "Changes to be committed") || -n $(git status | grep "Untracked files") || -n $(git status | grep "Changes not staged") ]]; do

#process git commands until the repo is up-to-date
			if [[ -n $(git status | grep "Your branch is ahead") ]] ; then
				echo -e "${BLUE}$i${NC}: pushing commits"
				git push 1>/dev/null
				echo -e "${BLUE}$i${NC}: pushing commits - ${GREEN}DONE${NC}"
			fi
			if [[ -n $(git status | grep "Changes to be committed") ]]; then
				echo -e "${BLUE}$i${NC}: committing changes"
				git commit -m "auto-generated commit" 1>/dev/null
			fi
			if [[ -n $(git status | grep "Changes not staged") || -n $(git status | grep "Untracked files") ]] ; then
				echo -e "${BLUE}$i${NC}: staging changes for commit"
				git add . 1>/dev/null
			fi
		done
		echo -e "${BLUE}$i${NC}: ${GREEN}check done${NC}\n"
		cd $OLDPWD
	fi
done
echo -e "all done!\n"
