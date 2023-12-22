#!/bin/bash

read -p "What is your first name?" name
read -p "What is your surname?" surname
read -p "What is your extension number?" -N 4 extension
echo
read -p "What access code would you like to use when dialing in?" -N 4 -s access_code
echo
select phone in handheld headset; do
	echo "You chose: $phone"
	break
done
select department in finance sales 'customer service' engineering; do
	echo "You chose: $department"
	break
done
echo "$name,$surname,$extension,$access_code,$phone,$department" >> extensions.csv

