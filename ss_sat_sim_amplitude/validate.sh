#!/bin/bash
export PATH=../bin:$PATH

for file in $(ls run/run-1000[0-4].tsai); do
    
    gold=${file/run\//gold\/}

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

done

echo Validation succeded
exit 0

