#!/bin/bash

select city in London 'Los Angeles' Moscow Dubai; do
	case "$city" in
		London)
			echo "England";;
		"Los Angeles")
			echo "US";;
		Moscow)
			echo "Russia";;
		Dubai)
			echo "Emirates";;
	esac
break
done
