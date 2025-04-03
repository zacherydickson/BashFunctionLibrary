#!/bin/bash



#Generates a random string of a given length that will be useful for file names
#Inputs - The length of the string
function RandomString {
    #Run in a subshell to prevent variable leakage
    (
        execDir=$(dirname $(readlink -f ${BASH_SOURCE[0]}));
	    len=$1; shift
	    [ -z $len ] && len=8;
	    len=$(( ${len%%\.*}  +0 )) #ensure integer
	    if [ $len -eq 0 ]; then
	    	>&2 echo "[WARNING] Request for a random string of invalid length ($len) - Using 8"
	    	len=8;
	    fi
	    head "/dev/urandom" | tr -dc "A-Za-z0-9" | head -c $len
    )
    #Forward subshell result
    return $?
}

if [ ${BASH_SOURCE[0]} == ${0} ]; then
	RandomString "$@"
fi
