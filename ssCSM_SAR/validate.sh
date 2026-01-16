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

# Validate bundle_adjust results
for f in run/ba/run-lsz_03821_1cd_xku_16n196_v1.adjusted_state.json \
         run/ba/run-lsz_03822_1cd_xku_23n196_v1.adjusted_state.json \
         run/ba_state/run-run-lsz_03821_1cd_xku_16n196_v1.adjusted_state.json \
         run/ba_state/run-run-lsz_03822_1cd_xku_23n196_v1.adjusted_state.json; do

    g=${f/run\//gold\/}
    echo $f $g;
    if [ ! -f "$f" ]; then
		echo Missing $f
		exit 1
	fi
	if [ ! -f "$g"  ]; then
      echo "ERROR: Missing $f or $g"
      exit 1
    fi

    diff=$(diff $f $g)
    echo Diff for $f is $diff
    if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
    fi
done

echo Validation succeeded
exit 0

