#!/bin/bash  

file=$1

cat -n $file | head -n 20 | tail -n 11 | tac