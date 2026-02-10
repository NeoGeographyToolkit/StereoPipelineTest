#!/bin/bash
export PATH=../bin:$PATH

file=run/merged-left_sub16__right_sub16.match
gold=gold/merged-left_sub16__right_sub16.match

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1
fi

echo Comparing $file and $gold

diff=$(cmp $file $gold 2>&1)

if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
