#!/bin/bash
export PATH=../bin:$PATH

file=run/DMS_20171029_183704_02500_RPC.tsai
gold=gold/DMS_20171029_183704_02500_RPC.tsai

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

diff=$(diff $file $gold)

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeded
exit 0

