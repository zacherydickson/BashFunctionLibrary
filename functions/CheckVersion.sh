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
        lessOp="-lt"
        greaterOp="-gt"
        if [[ "$lowerStr" =~ ^\+ ]]; then
            lowerStr="${lowerStr%+}"
            lessOp="-le"
        fi
        if [ -n "$upperStr" ] && [[ "$upperStr" =~ ^- ]]; then
            upperStr="${upperStr%-}"
            greaterOp="-ge"
        fi
        read -a sv <<< $(ParseSemanticVersion "$svStr");
        read -a lower <<< $(ParseSemanticVersion "$lowerStr");
        #default upper to be one patch higher than the test version
        declare -a upper=("${sv[@]}")
        (( upper["$patchIdx"]++ ))
        if [ -n "$upperStr" ]; then
            read -a upper <<< $(ParseSemanticVersion "$upperStr");
        fi
        for i in "$majorIdx" "$minorIdx" "$patchIdx"; do
            minTest="[ ${sv["$i"]} $lessOp ${lower["$i"]} ]"
            maxTest="[ ${sv["$i"]} $greaterOp ${upper["$i"]} ]"
            if eval "$minTest" || eval "$maxTest"; then
                return "$EXIT_FAILURE"
            fi
        done
        #if [[ "$targetStr" =~ "\.+-\.+" ]]; then
        #    >&2 echo "RangeCase"
        #    #Range of versions case
        #    read -d '-' -a targetRange <<< "$targetStr";
        #    read -a minTarget <<< $(ParseSemanticVersion "${targetRange[0]}");
        #    read -a maxTarget <<< $(ParseSemanticVersion "${targetRange[1]}");
        #    for i in "$majorIdx" "$minorIdx" "$patchIdx"; do
        #        
        #    done
        #elif [[ "$targetStr" =~ \+$ ]]; then
        #    >&2 echo "MinCase"
        #    targetStr="${targetStr%+}"
        #    #Minimum Version Case
        #    read -a minTarget <<< $(ParseSemanticVersion "$targetStr");
        #    for i in "$majorIdx" "$minorIdx" "$patchIdx"; do
        #        if [ "${sv["$i"]}" -gt "${minTarget["$i"]}" ]; then
        #            return "$EXIT_SUCCESS"
        #        elif [ "${sv["$i"]}" -lt "${minTarget["$i"]}" ]; then
        #            return "$EXIT_FAILURE"
        #        fi
        #    done
        #else
        #    >&2 echo "ExactCase"
        #    #Exact Version Case
        #    read -a exactTarget <<< $(ParseSemanticVersion "$targetStr");
        #    for i in "$majorIdx" "$minorIdx" "$patchIdx"; do
        #        if [ "${sv["$i"]}" -ne "${exactTarget["$i"]}" ]; then
        #            return "$EXIT_FAILURE"
        #        fi
        #    done
        #fi

    )
    #Forward subshell exit code
    return $?;
}


if [ ${BASH_SOURCE[0]} == ${0} ]; then
	CheckVersion "$@"
fi
