#!/bin/bash
export PATH=../bin:$PATH

ans=$(../bin/max_err.pl run/run.txt gold/run.txt 1e-9) # compare the error
if [ "$ans" -eq 0 ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeded
exit 0
