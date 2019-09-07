#!/bin/bash
export PATH=../bin:$PATH

for ot in Byte UInt16 Int16 UInt32 Int32 Float32; do
	f=run/run_${ot}.r25.xml
	g=gold/run_${ot}.r25.xml

	if [ ! -e "$g" ]; then
            echo "ERROR: File $g does not exist."
            exit 1
	fi
        
	if [ ! -e "$f" ]; then
            echo "ERROR: File $f does not exist."
            exit 1
	fi

        diff $f $g
        
        max_err.pl $f $g # print the error
        ans=$(max_err.pl $f $g 1e-12) # compare the error
        if [ "$ans" -eq 0 ]; then
            echo Validation failed
            exit 1
        fi
        
        file=run/run_${ot}.r25.tif
	gold=gold/run_${ot}.r25.tif

	echo Comparing $file $gold

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
	gdalinfo -stats $file | grep -v Files | grep -v -i -E "tif|xml|imd" > run.txt
        ans=$?
        if [ "$ans" -ne 0 ]; then
            echo Validation failed
            exit 1
        fi
        
        gdalinfo -stats $gold | grep -v Files | grep -v -i -E "tif|xml|imd" > gold.txt
        ans=$?
        if [ "$ans" -ne 0 ]; then
            echo Validation failed
            exit 1
        fi
        
	diff=$(diff run.txt gold.txt)
	cat run.txt

	rm -f run.txt gold.txt

	echo diff is $diff
	if [ "$diff" != "" ]; then
	    echo Validation failed
	    exit 1
	fi

done

echo Validation succeded
exit 0


