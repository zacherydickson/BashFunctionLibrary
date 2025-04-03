#!/bin/bash

#Checks if a command can be found in the PATH variable
#Inputs - a command
#Output - None, check exit status
function CheckDependency {
    #Subshell to prevent variable leakage
    (
        execDir=$(dirname $(readlink -f ${BASH_SOURCE[0]}));
        source "$execDir/../variables/ExitStates.sh" || return 1;
    	depend=$1; shift
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
	CheckDependency "$@"
fi
