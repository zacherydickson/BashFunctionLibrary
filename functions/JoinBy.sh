#!/bin/bash

#Taken from stackoverflow question 1527049
# Answer from user Nicholas Sushkin


#Given a delimeter of arbitrary length, concats the arguments into a delimited string
#Inputs - An arbitrary length delimiter
#		- An arbitraty number of arguments
#Output - A delimited string
function JoinBy {
    #Run in a subshell to prevent variable leakage
    (
        execDir=$(dirname $(readlink -f ${BASH_SOURCE[0]}));
	    local d=${1-} f=${2-}
	    if shift 2; then
	    	printf %s "$f" "${@/#/$d}"
	    fi
    )
    return $?
}

if [ ${BASH_SOURCE[0]} == ${0} ]; then
	JoinBy "$@"
fi
