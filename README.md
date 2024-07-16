# Bash Function Library
A collection of Bash scripts intended to be used as a library of common, source-able functions
Each function is encapsulated in its own script, which is also callable from the command line.

The scripts are grouped together by functional category.

A [test script](runTests.sh), is included which will test the basic functionality of each function. It can be run with
```
    ./runTests.sh
    #Failures only
    ./runTests/sh -q
```

## Pipeline Development

[CheckDependency](scripts/CheckDependency.sh): Given a command, checks if it can be found in the PATH variable

## Number Processing

[IsNumeric](scripts/IsNumeric.sh): Uses regular expressions to determine if a string is a numeric value of different types; see the file for all numeric types supported

## String Processing

[JoinBy](scripts/JoinBy.sh): Given an arbitrary delimiter, join an arbitrary number of arguments into a string

[RandomString](scripts/RandomString.sh): Generates a string of a given length which will make valid file names

## Variables

These scripts are meant only to be sourced

[ExitStates](variables/ExitStates.sh): Contains named variables for exit states to improve code readability
