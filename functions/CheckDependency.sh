#!/bin/bash

#Checks if a command can be found in the PATH variable
#Inputs - a command
#Output - None, check exit status
function CheckDependency {
	local exit_failure=1;
	depend=$1; shift
	if [ -z $depend ]; then
		>&2 echo "[ERROR] Attempt to check an empty dependency"
		return $exit_failure;
	elif ! which $depend > /dev/null; then
		>&2 echo "[ERROR] Could not locate $depend, install or check your PATH"
		return $exit_failure;
	fi
}

if [ ${BASH_SOURCE[0]} == ${0} ]; then
	CheckDependency "$@"
fi
