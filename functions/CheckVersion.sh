#!/bin/bash

#Checks if the semantic version meets requirements
#   Note all inputs are interpretted by ParseSemantic Version
#Inputs - a semantic version (often the result of a command)
#       - a lower bound semantic version, may have a '+' prefix to indicate the version must be higher 
#       - an optional upper bound semantic version, may have a '-' prefix to indicate the verson must be lower
#       -   if not provided, it is set at the test version
#Output - None, check exit status
function CheckVersion {
    #Subshell to prevent variable leakage
    (
        execDir=$(dirname $(readlink -f ${BASH_SOURCE[0]}));
        source "$execDir/../variables/ExitStates.sh" || return 1;
        source "$execDir/../functions/ParseSemanticVersion.sh" || return 1;
    	svStr=$1; shift
        lowerStr=$1; shift
        upperStr=$1; shift
        majorIdx=0;
        minorIdx=1;
        patchIdx=2;
    	if [ -z "$svStr" ] || [ -z "$lowerStr" ] ; then
    		>&2 echo "[ERROR] Attempt to CheckVersion with either an empty version or target"
    		return $EXIT_FAILURE;
    	fi
        #Determine if the range termini are open or closed
        lowerMinAccept=0;
        upperMaxAccept=0;
        maxFailOp="-gt"; maxPassOp="-lt"
        if [[ "$lowerStr" =~ ^\+ ]]; then
            lowerStr="${lowerStr#+}"
            lowerMinAccept=1;
        fi
        if [ -n "$upperStr" ] && [[ "$upperStr" =~ ^- ]]; then
            upperStr="${upperStr#-}"
            upperMaxAccept=-1;
        fi
        read -a sv <<< $(ParseSemanticVersion "$svStr");
        read -a lower <<< $(ParseSemanticVersion "$lowerStr");
        #default upper to be one patch higher than the test version
        declare -a upper=("${sv[@]}")
        (( upper["$patchIdx"]++ ))
        if [ -n "$upperStr" ]; then
            read -a upper <<< $(ParseSemanticVersion "$upperStr");
        fi
        cmpMin=0
        cmpMax=0;
        #Compare the test version to the lower and upper bounds
        for i in "$majorIdx" "$minorIdx" "$patchIdx"; do
            if [ "$cmpMin" -eq 0 ]; then
                [ "${sv[$i]}" -gt "${lower[$i]}" ] && cmpMin=1;
                [ "${sv[$i]}" -lt "${lower[$i]}" ] && cmpMin=-1;
            fi
            if [ "$cmpMax" -eq 0 ]; then
                [ "${sv[$i]}" -gt "${upper[$i]}" ] && cmpMax=1;
                [ "${sv[$i]}" -lt "${upper[$i]}" ] && cmpMax=-1;
            fi
        done
        #Test if the targets are met
        [ "$cmpMin" -lt "$lowerMinAccept" ] && return "$EXIT_FAILURE";
        [ "$cmpMax" -gt "$upperMaxAccept" ] && return "$EXIT_FAILURE"
        return "$EXIT_SUCCESS"
    )
    #Forward subshell exit code
    return $?;
}


if [ ${BASH_SOURCE[0]} == ${0} ]; then
	CheckVersion "$@"
fi
