#!/bin/bash

execDir=$(dirname $(readlink -f $0));

if [ "$#" -lt 1 ]; then
	>&2 echo -e "Usage: $(basename $0) Prefix1 ... \n" \
		"\tSearches the function and variable libraries to find the unique\n" \
		"\t\t set of files matching any of the given prefixes\n" \
		"\tReturns the absolute path to the files\n" \
		"\tUse an empty prefix to list all files available\n";
	exit 1;
fi

for prefix in "$@"; do 
	find "$execDir/functions" "$execDir/variables" -type f \
		-name "$prefix*" -exec readlink -f {} \;
done | 
	sort -u
