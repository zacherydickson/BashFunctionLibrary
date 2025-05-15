#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"

execDir=$(dirname $(readlink -f $0));

cd "$execDir/functions";
VERBOSE=1
TargetScript="";

while getopts 's:q' opts; do
	case $opts in
		s)
			TargetScript=$OPTARG
			;;
		q)
			VERBOSE=0
			;;
	esac
done

########################
#Set the tests Up
#######################

declare -A testList;
Script="JoinBy"
testList["$Script:basic"]='[ $(./JoinBy.sh , 5 6 7) == "5,6,7" ]'
testList["$Script:noarg"]='[ -z $(./JoinBy.sh) ]'
testList["$Script:delim-only"]='[ -z $(./JoinBy.sh ,) ]'
testList["$Script:no-join"]='[ $(./JoinBy.sh , 5) == "5" ]'
Script="CheckDependency"
testList["$Script:basic"]='./CheckDependency.sh ls'
testList["$Script:noarg"]='! ./CheckDependency.sh 2> /dev/null'
testList["$Script:missing"]='! ./CheckDependency.sh NonSen-seCommand_ 2> /dev/null'
Script="CheckFile"
testList["$Script:basic"]="./CheckFile.sh $execDir/README.md"
testList["$Script:noarg"]='! ./CheckFile.sh 2> /dev/null'
testList["$Script:missing"]='! ./CheckFile.sh MiSsInGfIlE 2> /dev/null'
testList["$Script:missing:desc"]='./CheckFile.sh MiSsInGfIlE Descriptor 2>&1 | grep -q Descriptor'
testList["$Script:missing:warn"]='./CheckFile.sh MiSsInGfIlE Desc WARNING 2>&1 | grep -q WARNING'
testList["$Script:empty"]='! ./CheckFile.sh ../testData/empty_file 2> /dev/null'
Script="CheckVersion"
testList["$Script:noarg"]='! res=$(./CheckVersion.sh                                 2>&1 1>/dev/null) && [ -n "$res" ]'
testList["$Script:nomin"]='! res=$(./CheckVersion.sh V05.05.05                       2>&1 1>/dev/null) && [ -n "$res" ]'
testList["$Script:exact:pass"]='! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -z "$res" ]'
testList["$Script:exact:high"]='! res=$(./CheckVersion.sh V05.05.06 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -z "$res" ]'
testList["$Script:exact:low"]='! res=$(./CheckVersion.sh V05.05.04 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -z "$res" ]'
#testList["$Script:exact:nomin"]='! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:exact:lomaj"]='! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:exact:himaj"]='! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:exact:lomin"]='! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:exact:himin"]='! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:exact:lopat"]='! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:exact:hipat"]='! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:min:lopat"]=  '! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:min:lomin"]=  '! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:min:lomaj"]=  '! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:min:eq"]=     '! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:min:gtpat"]=  '! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:min:gtmin"]=  '! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:min:gtmaj"]=  '! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:min:eqmaj"]=  '! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#testList["$Script:rng:in"]=     '! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
#TODO: Tests for Min and range cases
#testList["$Script:rng:in"]=     '! res=$(./CheckVersion.sh V05.05.05 SV05.05.05 SV05.05.05 2>&1 1>/dev/null) && [ -n "$res" ]'
Script="IsNumeric"
#		 0	     1    2    3      4   5     6    7  8    9          10 		
#		 11      12   13   14     15  16    17   18 19   20         21
#		 22      23   24   25     26  27    28   29 30   31         32
#        33 34  35 36 37   38     39     40            41     42    43
testVal=(-100.56 -100 -012 -11.22 -11 -11.0 -5.9 -1 -0.8 -0.0001000 -0.0000007 \
		  100.56  100  012  11.22  11  11.0  5.9  1  0.8  0.0001000  0.0000007 \
		 +100.56 +100 +012 +11.22 +11 +11.0 +5.9 +1 +0.8 +0.0001000 +0.0000007 \
		 -0 -0.0 0 +0 +0.0 "-dog" "+dog" "mouse.house" "'5 6'" "' 510'" "'-24	'")
numTypeList=(Real PosReal NonNegReal NegReal NonPosReal \
				Int Natural Whole NegInt NonPosInt \
				UnitIV Unrecognized);
for numType in "${numTypeList[@]}"; do
	case $numType in
		Unrecognized) : ;&
		Real) negateIdxList=($(seq 38 41) 44);;
		PosReal) negateIdxList=($(seq 0 10) $(seq 33 41) 43 44);;
		NonNegReal) negateIdxList=($(seq 0 10) $(seq 38 41) 43 44);;
		NegReal) negateIdxList=($(seq 11 42) 44);;
		NonPosReal) negateIdxList=($(seq 11 32) $(seq 38 42) 44);;
		Int) negateIdxList=(0 3 5 6 $(seq 8 11) 14 16 17 $(seq 19 22) 25 27 28 30 31 32 34 37 $(seq 38 41) 44);;
		Natural) negateIdxList=($(seq 0 11) 14 16 17 $(seq 19 22) 25 27 28 $(seq 30 41) 43 44);;
		Whole) negateIdxList=($(seq 0 11) 14 16 17 $(seq 19 22) 25 27 28 $(seq 30 32) 34 $(seq 37 41) 43 44);;
		NegInt) negateIdxList=(0 3 5 6 $(seq 8 42) 44);;
		NonPosInt) negateIdxList=(0 3 5 6 $(seq 8 32) 34 $(seq 37 42) 44);;
		UnitIV) negateIdxList=($(seq 0 17) $(seq 22 28) $(seq 38 44));;
	esac
	negateIdxIdx=0;
	for i in $(seq 0 ${#testVal[@]}); do
		val="${testVal[$i]}"
		if [ $i -eq ${#testVal[@]} ]; then
			#Note: an extra test is added on at the end for an empty number, it should alway fail
			val="";
		fi
		key="$Script:$numType:$val"
		testStr="./IsNumeric.sh $val $numType 2> /dev/null"
		#For unrecognized numeric types we want to also check that the warning is printed
		if [ $numType == "Unrecognized" ] && [ $i -lt ${#testVal[@]} ]; then
			testStr="res=\$($testStr 2>&1) && [ -n \"\$res\" ]"
		fi
		#test if the negate list is exhausted			test if the current index is the next negate Idx
		if [ $negateIdxIdx -lt ${#negateIdxList[@]} ] && [ $i -eq ${negateIdxList[$negateIdxIdx]} ]; then
			testStr="! $testStr"
			((negateIdxIdx++)) #Increment the index in the negate list
		fi
		testList["$key"]="$testStr"
	done
done
Script="ParseSemanticVersion"
testList["$Script:noarg"]='[ -z $(./ParseSemanticVersion.sh 2> /dev/null) ]'
testList["$Script:basic"]='[[ $(./ParseSemanticVersion.sh V10.5.6) == "10 5 6" ]]'
testList["$Script:no-v"]='[[ $(./ParseSemanticVersion.sh 10.5.6) == "10 5 6" ]]'
testList["$Script:lower-v"]='[[ $(./ParseSemanticVersion.sh v10.5.6) == "10 5 6" ]]'
testList["$Script:nonsv"]='[[ $(./ParseSemanticVersion.sh may24e7) == "0 0 0" ]]'
testList["$Script:nopatch"]='[[ $(./ParseSemanticVersion.sh V10.5) == "10 5 0" ]]'
testList["$Script:majoronly"]='[[ $(./ParseSemanticVersion.sh V10) == "10 0 0" ]]'
testList["$Script:mixedsv"]='[[ $(./ParseSemanticVersion.sh V10.5.24e7) == "10 5 0" ]]'
Script="RandomString"
testList["$Script:noarg"]='res=$(./RandomString.sh) && [ ${#res} -gt 0 ]'
testList["$Script:length:10"]='res=$(./RandomString.sh 10) && [ ${#res} -eq 10 ]'
testList["$Script:length:0a"]='res=$(./RandomString.sh 0 2>&1 1>/dev/null) && [ -n "$res" ]'
testList["$Script:length:0b"]='res=$(./RandomString.sh 0 2> /dev/null) && [ -n $res ]'
testList["$Script:float:a"]='res=$(./RandomString.sh 6.5 2>&1 1>/dev/null) && [ -z $res ]'
testList["$Script:float:b"]='res=$(./RandomString.sh 6.5) && [ ${#res} -eq 6 ]'
testList["$Script:str:a"]='res=$(./RandomString.sh mouse 2>&1 1>/dev/null) && [ -n "$res" ]'
testList["$Script:str:b"]='res=$(./RandomString.sh mouse 2> /dev/null) && [ -n $res ]'


###############
#Run the tests
###############

declare -A TestCount;
declare -A PassCount;
FinalRes="${GREEN}All Tests Pass${NC}"

while read -r key; do
    script=$(echo $key | awk -F ':' '{print $1}');
	if [ -n "$TargetScript" ]; then
		! [[ $key =~ "$TargetScript" ]] && continue;
	fi
    #Test in the command line call configuration
	if eval "${testList[${key}]}"; then
	    [ $VERBOSE -eq 1 ] && >&2 echo -e "[${GREEN}PASS${NC}] $key"
        ((PassCount[$script]++))
    else
        >&2 echo -e "[${RED}FAIL${NC}] $key";
        FinalRes="${RED}Some Tests Failed${NC}"
    fi
    #Test in the sourced configuration
    cmd="( cd ..; source functions/$script.sh; ${testList[${key}]/.\/$script.sh/$script} 2>/dev/null; )";
    if eval "$cmd"; then
	    [ $VERBOSE -eq 1 ] && >&2 echo -e "[${GREEN}PASS${NC}] $key:sourced"
        ((PassCount[$script]++))
    else
        >&2 echo -e "[${RED}FAIL${NC}] $key:sourced"; 
        FinalRes="${RED}Some Tests Failed${NC}"
    fi
    ((TestCount[$script]+=2))
done < <( for k in "${!testList[@]}"; do echo $k; done | sort )
#Process Redirect to prevent subshells and sort


while read -r script; do
	if [ -n "$TargetScript" ]; then
		! [[ $script =~ "$TargetScript" ]] && continue;
    fi
    result="[${GREEN}PASS${NC}]"
    ((PassCount[$script]+=0))
    [ ${PassCount[$script]} -lt ${TestCount[$script]} ] && result="[${RED}FAIL${NC}]"
    >&2 printf "%b %20s: %4d / %4d Passing\n" $result $script ${PassCount[$script]} ${TestCount[$script]}
done < <( for s in "${!TestCount[@]}"; do echo $s; done | sort)
#Process Redirect to prevent subshells and sort

>&2 echo -e "$FinalRes"
