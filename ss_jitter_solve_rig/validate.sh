#!/bin/bash
export PATH=../bin:$PATH

for file in \
	run/run-linescan-fwd-c1.adjusted_state.json\
	run/run-linescan-fwd-c2.adjusted_state.json\
	run/run-linescan-nadir-c1.adjusted_state.json\
	run/run-linescan-nadir-c2.adjusted_state.json\
	; do 

    gold=gold/$(basename $file)

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

echo Validation succeeded
exit 0

