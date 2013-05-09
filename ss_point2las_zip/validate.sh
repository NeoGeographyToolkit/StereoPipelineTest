#!/bin/bash

file=run/run-LAS.laz
gold=gold/run-LAS.laz

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

lasinfo $file | grep -v Creation > run.txt
status=$?
if [ $status -ne 0 ]; then
    echo Validation failed
    exit 1
fi

lasinfo $gold |grep -v Creation > gold.txt
status=$?
if [ $status -ne 0 ]; then
    echo Validation failed
    exit 1
fi

diff=$(diff run.txt gold.txt)
cat run.txt

rm -f run.txt gold.txt

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeded
exit 0
