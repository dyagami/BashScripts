#!/bin/bash

read -p "enter a number:" number
case "$number" in 
	[0-9])
		echo "you have entered a single digit number";;
	[0-9][0-9])
		echo "you have entered a two digit nubmer";;
	[0-9][0-9][0-9])
		echo "you have entered a three digit number";;
esac
