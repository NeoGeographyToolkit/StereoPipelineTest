#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-run-l.adjusted_state.json         \
    run/run-run-p-1000{0,1,2,3,4}.adjusted_state.json \
    run/jitter/run-run-l.adjusted_state.json          \
    run/jitter/run-run-p-1000{0,1,2,3,4}.adjusted_state.json; do

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
    
	echo diff $file $gold
    echo diff is $diff
    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi

done

echo Validation succeded
exit 0

