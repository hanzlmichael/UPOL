#!/bin/bash

function rotate 
{
	file=$1
    
	if [ -z $2 ]; then
	   count=30
	else
	   count=$2
	fi
	
	if [ -e "$file.$count" ]; then
		rm "$file.$count"
	fi

	count=$((count - 1))

	for ((i=$count; i>=0; i--)); do
		if [ -e "$file.$i" ]; then	
		mv "$file.$i" "$file.$((i + 1))"
		fi
	done
	new=0

	mv $file "$file.$new"

	echo Hotovo
	ls
}

rotate $*