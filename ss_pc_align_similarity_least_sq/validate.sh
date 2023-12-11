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
    gdalinfo -stats $file |grep -v xml > run/run.txt
    gdalinfo -stats $gold |grep -v xml > gold/run.txt
    ../bin/max_err.pl run/run.txt gold/run.txt
	ans=$(../bin/max_err.pl run/run.txt gold/run.txt 1e-6)
	if [ "$ans" -eq 0 ]; then
	     echo Validation failed
	     exit 1
	fi
done

echo Validation succeded
exit 0

