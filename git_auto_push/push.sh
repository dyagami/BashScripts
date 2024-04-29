#!/bin/bash

BLUE='\033[0;34m'
GREEN='\033[1;32m'
NC='\033[0m'
clear
for i in $( ls ); do
	if [[ -d $i && "$i" != '.' && "$i" != '..' ]] ; then
		echo -e "checking: ${BLUE}$i${NC}"
		cd $i
		while [[ -n $(git status | grep "Your branch is ahead") || -n $(git status | grep "Changes to be committed") || -n $(git status | grep "Untracked files") || -n $(git status | grep "Changes not staged") ]]; do
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
#Your branch is up to date with 'origin/master'.
#nothing to commit, working tree clean

#Your branch is up to date with 'origin/master'.
#Untracked files:
#(use "git add <file>..." to include in what will be committed)
#test
#nothing added to commit but untracked files present (use "git add" to track)

#Your branch is up to date with 'origin/master'.
#Changes to be committed:
#(use "git restore --staged <file>..." to unstage)
#new file:   test

#Your branch is ahead of 'origin/master' by 1 commit.
#(use "git push" to publish your local commits)
#nothing to commit, working tree clean
