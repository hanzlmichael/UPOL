#!/bin/bash

function convert_from_decimal () 
{
   alphabeth='0123456789abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ@_'

    number=$1
    baseTo=$2
    result=""

    for (( ; $number!=0; )); do
       remainder=$((number % baseTo))
       number=$((number / baseTo))
       temp=${alphabeth:remainder:1}
       result=$temp$result     
    done

    echo $result 
}

function convert_to_decimal ()
{
    alphabeth='0123456789abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ@_'

    number=$1
    baseFrom=$2
    result=""
    len=${#number}
    exponent=$((${#number} - 1))

    for (( c=0; c<$len; c++ )); do
        temp=${number:c:1}
        test=$((`expr index "$alphabeth" $temp` - 1))
        tempResult=$((test * baseFrom ** exponent))
        exponent=$((exponent - 1))
        result=$((result + tempResult))
    done

    echo $result
}

convert_from_decimal 222 3
convert_from_decimal 222 32
convert_from_decimal 222 16
convert_to_decimal 22020 3
convert_to_decimal de 16
convert_to_decimal 6u 32