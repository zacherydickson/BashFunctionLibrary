#!/bin/bash

#Checks if a file exists and is non-empty
#Inputs - a File
#		- an optional descriptor for the file (File as default)
#		- an optional exit message descriptor (ERROR as default
#Output - None, check exit status
function CheckFile {
	local exit_failure=1;
	file=$1; shift;
	desc=$1; shift;
	level=$1; shift;
	[ -z "$desc" ] && desc="File";
	[ -z "$level" ] && level="ERROR";
	if [ -z "$file" ]; then
		>&2 echo "[ERROR] Attempt to check an empty file name"
		return $exit_failure;
	elif ! [ -f "$file" ] || ! [ -s "$file" ]; then 
		>&2 echo "[$level] $desc ($file) missing or empty";
		return $exit_failure;
	fi
}

if [ ${BASH_SOURCE[0]} == ${0} ]; then 
	CheckFile "$@"
fi
