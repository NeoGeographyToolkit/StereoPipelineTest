#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-trans_reference.tif run/run-trans_source.tif; do
	gold=${file/run\/run/gold\/run}

	if [ ! -e "$file" ]; then
    	echo "ERROR: File $file does not exist."
	    exit 1;
	fi

	if [ ! -e "$gold" ]; then
	    echo "ERROR: File $gold does not exist."
	    exit 1;
	fi

	diff=$(cmp $file $gold | head -n 50)
	ans=$?
	echo "diff is $diff"
	echo "return flag is $ans"
	if [ "$diff" != "" ] || [ "$ans" -ne 0 ]; then
	    echo Validation failed
	    exit 1
	fi
done

echo Validation succeded
exit 0

