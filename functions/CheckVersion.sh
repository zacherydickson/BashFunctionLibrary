#!/bin/bash

#Checks if the semantic version meets requirements
#Inputs - a target semantic version, which can be in the format SV(+|SV)?
#           SV checks that athe result version matches the target
#           SV+ checks that the result version is at least the target
#           SV-SV checks that the result version is within the target range
#       - a semantic version (often the result of a command)
#Output - None, check exit status
function CheckVersion {
    #Subshell to prevent variable leakage
    (
        execDir=$(dirname $(readlink -f ${BASH_SOURCE[0]}));
        source "$execDir/../variables/ExitStates.sh" || return 1;
        source "$execDir/../functions/ParseSemanticVersion.sh" || return 1;
        targetStr=$1; shift
    	svStr=$1; shift
        majorIdx=0;
        minorIdx=1;
        patchIdx=2;
    	if [ -z "$svStr" ] || [ -z "$targetStr" ] ; then
    		>&2 echo "[ERROR] Attempt to CheckVersion with either an empty version or target"
    		return $EXIT_FAILURE;
    	fi
        read -a sv <<< $(ParseSemanticVersion "$svStr");
        if [[ "$targetStr" =~ "\.+-\.+" ]]; then
            #Range of versions case
            read -d '-' -a targetRange <<< "$targetStr";
            read -a minTarget <<< $(ParseSemanticVersion "${targetRange[0]}");
            read -a maxTarget <<< $(ParseSemanticVersion "${targetRange[1]}");
            for i in "$majorIdx" "$minorIdx" "$patchIdx"; do
                if  [ "${sv["$i"]}" -lt "${minTarget["$i"]}" ] ||
                    [ "${sv["$i"]}" -gt "${maxTarget["$i"]}" ]; then
                    return "$EXIT_FAILURE"
                fi
            done
        elif [[ "$targetStr" =~ "\.+$" ]]; then
            targetStr="${targetStr%+}"
            #Minimum Version Case
            read -a minTarget <<< $(ParseSemanticVersion "$targetStr");
            for i in "$majorIdx" "$minorIdx" "$patchIdx"; do
                if [ "${sv["$i"]}" -gt "${exactTarget["$i"]}" ]; then
                    return "$EXIT_SUCCESS"
                elif [ "${sv["$i"]}" -lt "${exactTarget["$i"]}" ]; then
                    return "$EXIT_FAILURE"
                fi
            done
        else
            #Exact Version Case
            read -a exactTarget <<< $(ParseSemanticVersion "$targetStr");
            for i in "$majorIdx" "$minorIdx" "$patchIdx"; do
                if [ "${sv["$i"]}" -ne "${exactTarget["$i"]}" ]; then
                    return "$EXIT_FAILURE"
                fi
            done
        fi

    )
    #Forward subshell exit code
    return $?;
}


if [ ${BASH_SOURCE[0]} == ${0} ]; then
	CheckVersion "$@"
fi
