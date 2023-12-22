#!/bin/bash

readarray -t urls < urls.txt

for i in "${urls[@]}"; do
	webname=$(echo $i | cut -d "." -f 2)
	curl $i --head > "$webname.txt"
done
