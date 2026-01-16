#!/bin/bash
export PATH=../bin:$PATH

 for file in run/run-left_bathy.adjusted_state.json \
             run/run-right_bathy.adjusted_state.json; do \
                
    gold=gold/$(basename $file)

    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi

    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1;
    fi

    # Print the error and check the status
    ../bin/max_err.pl $file $gold 
    ans=$?
    if [ "$ans" -ne 0 ]; then
        echo Validation failed
        exit 1
    fi

    ans=$(../bin/max_err.pl $file $gold 5e-8)
    if [ "$ans" != "1" ]; then
        echo Validation failed
        exit 1
    fi

done

echo Validation succeeded
exit 0
