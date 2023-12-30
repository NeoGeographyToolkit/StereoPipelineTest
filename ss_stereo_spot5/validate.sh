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

../bin/max_err.pl $file $gold
ans=$(../bin/max_err.pl $file $gold 1e-3 | grep -v Warn) # compare the error
if [ "$ans" -eq 0 ]; then
    echo Validation failed
    exit 1
fi

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeded
exit 0

