#!/bin/bash  

if [ -z $1 ]; then
    echo Nebyl zadan parametr.
    exit 1
elif [ -z $2 ]; then
    d=1
    from=1
    to=$1
elif [ -z $3 ]; then
    d=1
    from=$1
    to=$2
else 
    d=$2
    from=$1
    to=$3
fi  

result=""
space=" "          

while [ $from -le $to ]; do
    combi=$from$space
    result+=$combi
    from=$((from+d))	
done

echo $result           