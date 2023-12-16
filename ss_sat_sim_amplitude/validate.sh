#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-10000.map.tsai \
            run/run-10001.map.tsai \
            run/run-10002.map.tsai \
            run/run-10003.map.tsai \
            run/run-10004.map.tsai; do 
            
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

