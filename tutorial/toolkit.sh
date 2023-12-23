#!/bin/bash

PS3="Select tool you want to use: "
select decision in "cruft_remover" "folder_organiser"; do
	case "$decision" in
		"cruft_remover")
			./cruft_remover.sh ;;
		"folder_organiser" )
			./folder_organiser.sh ;;
	esac
break
done
