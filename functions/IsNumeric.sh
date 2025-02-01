#!/bin/bash

#Tests if the first arguemt is of the numeric type defined by the second argument
#Zeros before decimal places are required, decimal places are not allowed for integers
#Leading and trailing whitespaces are ignored
#Inputs - A value to test
#		- A numeric type can be one of:
#			Real (default): (-∞,∞)εR
#			PosReal:		(0,∞)εR
#			NonNegReal:		[0,∞)εR
#			NegReal:		(-∞,0)εR
#			NonPosReal:		(-∞,0]εR
#			Int:			(-∞,∞)εZ
#			Natural:		[1,∞)εZ
#			Whole:			[0,∞)εZ
#			NegInt:			[-∞,-1]εZ
#			NonPosInt:		[-∞,0]εZ
#			UnitIV:			[0,1]εR
#Output - None, check exit status
function IsNumeric {
	local EXIT_FAILURE=1;
    val=$1; shift;
	#strip off leading and trailing spaces and tabs
	val=$(sed 's/^[[:blank:]]*//' <<< "$val" | sed 's/[[:blank:]]*$//')
	numType=$1; shift;
	[ -z $numType ] && numType="Real"
	if ! [ -z $numType ]; then
		case $numType in
			#Optional sign, followed by at least one digit, with optional point something
			Real)			re="^[+-]?[0-9]+([.][0-9]+)?$";;
			#Optional positive, followed by either zero point non-zero, 
			#	or at least one non-zero, with an optional point something
			PosReal)		re="^[+]?(0[.][0-9]*[1-9][0-9]*|[0-9]*[1-9][0-9]*([.][0-9]+)?)$";;
			#Optional positive, followed by at least one digit with optional point something
			# or negative zero with optional point zero
			NonNegReal)		re="^([+]?[0-9]+([.][0-9]+)?|-0([.]0+)?)$";;
			#Required negative, followed by either zero point non-zero,
			#	or at least one non zero with optional point something
			NegReal)		re="^-(0.[0-9]*[1-9][0-9]*|[0-9]*[1-9]+[0-9]*([.][0-9]+)?)$";;
			#Either optionally positive zero with optional point zero or negative something point something
			NonPosReal)		re="^([+]?0([.]0+)?|-[0-9]+([.][0-9]+)?)$";;
			#Optional Sign with at least one digit
			Int)			re="^[+-]?[0-9]+$";;
			#Optional positive with at least one non-zero digit
			PosInt) : ;&
			Natural)		re="^[+]?[0-9]*[1-9]+[0-9]*$";;
			#Optional positive with at least one digit, or negative zero
			NonNegInt) : ;&
			Whole)			re="^([+]?[0-9]+|-0)$";;
			#Required negative with at least one non-zero digit
			NegInt)			re="^-[0-9]*[1-9]+[0-9]*$";;
			#Either optionally signed zero, or required sign with at least one digit
			NonPosInt)			re="^[+-]?0$|^-[0-9]+$";;
			#Either X with optional point zero (X is either optionally positive 1 or optionally signed 0)
			# or optionally positive zero with optional point something
			UnitIV)			re="^(([+]?1|[+-]?0)([.]0+)?|[+]?0([.][0-9]+)?)$";;
			*) 
				re="^[+-]?[0-9]+([.][0-9]+)?$"
				>&2 echo "[WARNING] Unrecognized numeric type ($numType) argument to IsNumeric - assuming Real"
				;;

		esac
	fi
	if ! [[ $val =~ $re ]]; then
		>&2 echo "[INFO] $val is not a $numType number"
        return $EXIT_FAILURE;
    fi
}

if [ ${BASH_SOURCE[0]} == ${0} ]; then
	IsNumeric "$@"
fi
