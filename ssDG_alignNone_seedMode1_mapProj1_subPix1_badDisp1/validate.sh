#!/bin/bash
export PATH=../bin:$PATH

file=run/run-DEM.tif
gold=gold/run-DEM.tif

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

diff=$(diff run.txt gold.txt)
cat run.txt

rm -f run.txt gold.txt

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

# Check that the outputs have georeference
for f in $(ls run/*tif |grep -v PC); do
        if [[ $f =~ .*stats.tif ]]; then
                continue
        fi
	ans=$(gdalinfo $f |grep -i datum)
	echo Datum in $f is $ans
	if [ "$ans" = "" ]; then
		echo No georeference in $f
		exit 1
	fi
done

echo Validation succeded
exit 0
