#!/bin/bash
export PATH=../bin:$PATH

file=run/run-BSG-118-20220730-123737-33360052_georeferenced-pan.tsai 
gold=gold/run-BSG-118-20220730-123737-33360052_georeferenced-pan.tsai

if [ ! -f "$file" ] || [ ! -f "$gold" ]; then
	echo Missing $file or $gold
	exit 1
fi

max_err.pl $file $gold  # print the error
ans=$(max_err.pl $file $gold 1e-10) # compare the error
if [ "$ans" -eq 0 ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeded
exit 0
