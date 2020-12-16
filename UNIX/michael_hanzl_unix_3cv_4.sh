#!/bin/bash  

file1=$1
file2=$2

grep -v -f $file1 $file2 