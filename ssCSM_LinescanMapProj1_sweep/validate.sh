#!/bin/bash
export PATH=../bin:$PATH

file=run/run.txt
gold=gold/run.txt

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

ans=$(diff $file $gold)
echo Diff is $ans
if [ -n "$ans" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0

