#!/bin/bash

#Given a string assumed to be a sematic version, prints the major minor and patch version
#Any missing, or non-numeric portions are assumed to be zero
#Inputs - a String to be parsed as a semantic version
#Output one one line the Majr, Minor, and Patch Versions as space separated integers
function ParseSemanticVersion {
    #Subshell to prevent variable leakage
    (
        execDir=$(dirname $(readlink -f ${BASH_SOURCE[0]}));
        source "$execDir/../variables/ExitStates.sh" || return 1;
        source "$execDir/../functions/IsNumeric.sh" || return 1; 
        sv="$1"; shift
        if [ -z "$sv" ]; then
            >&2 echo "[ERROR] Attempt to parse an empty semantic version"
            return "$EXIT_FAILURE"
        fi
        IFS="." read -a sv <<< "$sv";
        sv[0]=$(tr -d 'vV ' <<< "${sv[0]}");
        for i in $(seq 0 2); do
            [ -z "${sv["$i"]}" ] && sv["$i"]=0;
            IsNumeric "${sv["$i"]}" NonNegInt 2> >(grep -v INFO >&2) || sv["$i"]=0;
        done
        echo "${sv[@]:0:3}"
    );
    #Forward subshell exit code
    return $?;
}

if  [ ${BASH_SOURCE[0]} == ${0} ]; then
	ParseSemanticVersion "$@"
fi
