#!/bin/bash  

file=$1

paste <(cut -f 2 $file)  <(cut -f 1 $file) <(cut -f 3- $file)