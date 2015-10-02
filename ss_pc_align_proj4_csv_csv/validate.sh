#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-trans_reference.csv run/run-trans_source.csv; do
	gold=${file/run\/run/gold\/run}

	if [ ! -e "$file" ]; then
    	echo "ERROR: File $file does not exist."
	    exit 1;
	fi

	if [ ! -e "$gold" ]; then
	    echo "ERROR: File $gold does not exist."
	    exit 1;
	fi

	diff=$(diff $file $gold)
	echo "diff is $diff"
	if [ "$diff" != "" ]; then
	    echo Validation failed
	    exit 1
	fi
done

echo Validation succeded
exit 0

