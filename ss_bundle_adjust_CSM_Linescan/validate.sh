#!/bin/bash
export PATH=../bin:$PATH

 for file in run/run-B17_016219_1978_XN_17N282W.8bit.adjusted_state.json \
             run/run-B18_016575_1978_XN_17N282W.8bit.adjusted_state.json \
             run/run-weight-run-B17_016219_1978_XN_17N282W.8bit.adjusted_state.json \
             run/run-weight-run-B18_016575_1978_XN_17N282W.8bit.adjusted_state.json \
             run/run-reuse-run-B17_016219_1978_XN_17N282W.8bit.adjusted_state.json \
             run/run-reuse-run-B18_016575_1978_XN_17N282W.8bit.adjusted_state.json; do

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

    ans=$(../bin/max_err.pl $file $gold 5e-6)
    if [ "$ans" != "1" ]; then
        echo Validation failed
        exit 1
    fi

done

echo Validation succeeded
exit 0
