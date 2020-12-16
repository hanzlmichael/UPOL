#!/bin/bash

if [ -z $1 && -z $2 ]; then
	from=0
	to=100
    echo Mysli si cislo mezi 0 a 100
elif [ -z $2 ]; then
	from=0
	to=$1
    echo Mysli si cislo mezi 0 a $1
else
	from=$1
	to=$2
    echo Mysli si cislo mezi $1 a $2
fi     

while [ true ]; do
	middle=$(((from+to)/2))
	echo ">"$middle"? (v = vetsi | m = mensi | a = ano tohle je me cislo)"
	read answer
	
	case $answer in
	v) from=$((middle+1))
	   count=$((count+1));;
	m) to=$middle
	   count=$((count+1));;
	a) echo Super!
           break;;       
	esac
done              