#!/bin/bash

function basename
{
    path=$1 
    lastchar=`echo "${path: -1}"`

    if [ $lastchar = '/' ]; then
        count=`grep -o '/' <<<"$path" | grep -c .`
        rev=`echo $path | cut -f$count -d"/"`
        echo $rev
    else
        dir="${path##*/}"
        echo $dir
    fi
}

function dirname
{
    path=$1
    lastchar=`echo "${path: -1}"`     
    dir="${path%/*}"        

	if [[ "${dir}" != */* ]]; then
		dir="."
        echo $dir
	elif [ $lastchar != '/' ]; then
        var=`echo $path | sed 's|\(.*\)/.*|\1|'`
        echo $var
    else
        withoutlast=${path::-1}
        var=`echo $withoutlast | sed 's|\(.*\)/.*|\1|'`
        echo $var
    fi
}

basename /media/psf/PhD/UNIX/Lectures/homework9.sh
dirname /media/psf/PhD/UNIX/Lectures/homework9.sh  
basename /media/psf/PhD/UNIX/
dirname /media/psf/PhD/UNIX/
basename homework.sh
dirname homework.sh