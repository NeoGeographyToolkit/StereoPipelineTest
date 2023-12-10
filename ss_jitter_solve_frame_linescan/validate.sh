#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-run-l.adjusted_state.json run/run-run-p-10000.adjusted_state.json run/run-run-p-10001.adjusted_state.json run/run-run-p-10002.adjusted_state.json run/run-run-p-10003.adjusted_state.json run/run-run-p-10004.adjusted_state.json; do 

    gold=${file/run\//gold\/}

    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi
    
    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1;
    fi
    
    diff=$(diff $file $gold | head -n 50)
    
    echo diff is $diff
    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi

done

echo Validation succeded
exit 0

