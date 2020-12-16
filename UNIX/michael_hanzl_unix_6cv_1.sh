#!/bin/bash

file=$1
mkdir $file

for i in {0001..1000}; do   
    day=$(($RANDOM%30 + 1))
    month=$(($RANDOM%11 + 1))
    year=$(($RANDOM%100 + 1920))
    printf "%02d/%02d/%04d" $month $day $year > $file/$i
done

echo Finished      
                                     
                                     
                        