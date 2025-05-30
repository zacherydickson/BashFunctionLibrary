# Bash Function Library
A collection of Bash scripts intended to be used as a library of common, source-able functions
Each function is encapsulated in its own script, which is also callable from the command line.
The function defined within each script matches the name of the script.
For example JoinBy.sh defines the function JoinBy.

The scripts are grouped together by functional category.

A [test script](runTests.sh) is included which will test the basic functionality of each function. It can be run with
```
    ./runTests.sh
    #Failures only
    ./runTests.sh -q
```

# Use the Library Files in your scripts

To use the functions and variables included in this library one can source the files as needed. For ease of access one might set up environment variables to the function and variable directories included. For example:

```
 export BASHFUNCLIB="/home/user/BashFunctionLibrary/functions"
 source "$BASHFUNCLIB/CheckDependency.sh"
```

Alternatively, a [find script](findLibFiles.sh) is included to return absolute paths based on a search of basename prefixes in this library. One could add this script to their path and call it from other scripts to get files names to source. For example:

```
    source $(findLibFiles.sh RandomStr);
    source $(findLibFiles.sh IsNumeric.sh);
```

If this grows unwieldy, one could use this script in a loop:

```
    for src in $(findLibFiles.sh Check Rand); do source "$f"; done
```

## Pipeline Development

[CheckDependency](scripts/CheckDependency.sh): Given a command, checks if it can be found in the PATH variable. If the dependency fails an error message is produced

[CheckFile](scripts/CheckFile.sh): Given a path to a file, checks if the file exists and is non-empty; can optionally provide a sort description of the file and an error level to provide more detailed messages on failure

[CheckVersion](scripts/CheckVersion.sh): Checks if a given semantic version meets a given target version; target can be exact (`V1.21.13`) a minimum (`V1.1+`) or a range (`V2.2.4-v3`)

## Number Processing

[IsNumeric](scripts/IsNumeric.sh): Uses regular expressions to determine if a string is a numeric value of different types; see the file for all numeric types supported

## String Processing

[JoinBy](scripts/JoinBy.sh): Given an arbitrary delimiter, join an arbitrary number of arguments into a string

[RandomString](scripts/RandomString.sh): Generates a string of a given length which will make valid file names

[ParseSemanticVersion](scripts/ParseSemanticVersion.sh): Extracts major minor and patch numbers for a semantic version string, missing or non-integer values default to 0

## Variables

These scripts are meant only to be sourced

[ExitStates](variables/ExitStates.sh): Contains named variables for exit states to improve code readability
