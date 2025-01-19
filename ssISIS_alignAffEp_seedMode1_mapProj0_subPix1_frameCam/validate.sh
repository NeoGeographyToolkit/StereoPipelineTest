#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-DEM.tif; do 
	gold=${file/run\//gold\/};

	echo $file $gold

	if [ ! -e "$file" ]; then
    	echo "ERROR: File $file does not exist."
	    exit 1;
	fi

	if [ ! -e "$gold" ]; then
	    echo "ERROR: File $gold does not exist."
	    exit 1;
	fi

	# Remove cached xmls
	rm -fv "$file.aux.xml"
	rm -fv "$gold.aux.xml"

	cmp_stats.sh $file $gold
	gdalinfo -stats $file | grep -v Files | grep -v -i tif > run.txt
	gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold.txt

	diff run.txt gold.txt

	max_err.pl run.txt gold.txt # print the error
	ans=$(max_err.pl run.txt gold.txt 1e-5) # compare the error
	if [ "$ans" -eq 0 ]; then
	    echo Validation failed
	    exit 1
	fi

	rm -f run.txt gold.txt

	echo diff is $diff
	if [ "$diff" != "" ]; then
	    echo Validation failed
	    exit 1
	fi

done

echo Validation succeeded
exit 0
