#!/bin/bash

readarray -t urls < urls.txt

for i in "${urls[@]}"; do
	curl $i --head > "$i.txt"
done
