#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-transform.txt; do 
	
	gold=gold/$(basename $file)

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

../bin/max_err.pl $file $gold
ans=$(../bin/max_err.pl $file $gold 2e-5 | grep -v Warn) # compare the error
if [ "$ans" -eq 0 ]; then
    echo Validation failed
    exit 1
fi

done

echo Validation succeeded
exit 0

