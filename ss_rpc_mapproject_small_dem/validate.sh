#!/bin/bash
export PATH=../bin:$PATH

for ot in Byte UInt16 Int16 UInt32 Int32 Float32; do

	file=run/run-RPC_${ot}.tif
	gold=gold/run-RPC_${ot}.tif

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
	gdalinfo -stats $file | grep -v Files | grep -v -i tif > run/run.txt
	gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold/run.txt

	diff=$(diff run/run.txt gold/run.txt)
	cat run/run.txt

	rm -f run/run.txt gold/run.txt

	echo diff is $diff
	if [ "$diff" != "" ]; then
	    echo Validation failed
	    exit 1
	fi

done

echo Validation succeeded
exit 0
