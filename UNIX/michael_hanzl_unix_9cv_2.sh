#!/bin/bash

file=$1
out=$2

awk '{for (i=1; i<=NF; i++) a[i,NR]=$i 
max=(max<NF?NF:max)} END {for (i=1; i<=max; i++) {for (j=1; j<=NR; j++) printf "%s%s", a[i,j], (j==NR?RS:FS) }}' $file > $out