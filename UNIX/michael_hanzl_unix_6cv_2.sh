#!/bin/bash

unzip fotky.zip

for i in fotky/* ; do
    date=`cat $i`
    path=`paste -d "/" <(echo $date | cut -f3 -d "/") <(echo $date | cut -f1 -d "/") <(echo $date | cut -f2 -d "/")`    
    mkdir -p sorted/$path
	cp $i sorted/$path/
    echo "$i is sorted"
done

