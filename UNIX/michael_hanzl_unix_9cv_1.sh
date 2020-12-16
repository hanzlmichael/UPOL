#!/bin/bash

file=$1

awk -v source=$1 '{words+=NF; tempchars+=length($0); chars=tempchars+(2*NF)} END {print NR,words,chars,source}' $file