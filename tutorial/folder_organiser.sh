#!/bin/bash

while read -r file; do
	case "$file" in
		*.jpg | *.jpeg | *.png )
			[ -d ./images ] || mkdir ./images
			mv "$file" ./images/ ;;
		*.doc | *.docx | *.txt | *.pdf )
			[ -d ./documents ] || mkdir ./documents
			mv "$file" ./documents/ ;;
		*.xls | *.xlsx | *.csv )
			[ -d ./spreadsheets ] || mkdir ./spreadsheets
			mv "$file" ./spreadsheets/ ;;
		*.sh )
			[ -d ./scripts ] || mkdir ./scripts
			mv "$file" ./scripts/ ;;
		*.zip | *.tar | *.tar.gz | tar.bz2 )
			[ -d ./archives ] || mkdir ./archives
			mv "$file" ./archives/ ;;
		*.ppt | *.pptx )
			[ -d ./presentations ] || mkdir ./presentations
			mv "$file" ./presentations/ ;;
		*.mp3 )
			[ -d ./audio ] || mkdir ./audio
			mv "$file" ./audio/ ;;
		*.mp4 )
			[ -d ./video ] || mkdir ./video
			mv "$file" ./video/ ;;
	esac
done < <( ls )
