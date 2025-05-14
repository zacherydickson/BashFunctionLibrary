#!/bin/bash

#Checks if the semantic version meets requirements
#Semantic versions must be in the format:
#       [vV]?[0-9+](\.[0-9]+(\.[0-9]+)?)?
#
#Inputs - a semantic version (often the result of a command)
#       - a target semantic version, which can be in the format SV(+|SV)?
#           SV checks that athe result version matches the target
#           SV+ checks that the result version is at least the target
#           SV-SV checks that the result version is within the target range
#Output - None, check exit status
function CheckVersion {
    #Subshell to prevent variable leakage
    (
        execDir=$(dirname $(readlink -f ${BASH_SOURCE[0]}));
        source "$execDir/../variables/ExitStates.sh" || return 1;
        source "$execDir/../functions/IsNumeric.sh" || return 1;
    	cmd=$1; shift
        target=$1; shift
    	if [ -z $depend ]; then
    		>&2 echo "[ERROR] Attempt to check an empty dependency"
    		return $EXIT_FAILURE;
    	elif ! which $depend > /dev/null; then
    		>&2 echo "[ERROR] Could not locate $depend, install or check your PATH"
    		return $EXIT_FAILURE;
    	fi
    )
    #Forward subshell exit code
    return $?;
}


if [ ${BASH_SOURCE[0]} == ${0} ]; then
	CheckVersion "$@"
fi
