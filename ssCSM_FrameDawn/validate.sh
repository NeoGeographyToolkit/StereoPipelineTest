#!/bin/bash
export PATH=../bin:$PATH

file=run/run-DEM.tif
gold=gold/$(basename $file)

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

# Validate the orthoimage (DRG) output
ortho=run/run-ortho-DRG.tif
ortho_gold=gold/run-ortho-DRG.tif

if [ ! -e "$ortho" ]; then
    echo "ERROR: File $ortho does not exist."
    exit 1;
fi

if [ ! -e "$ortho_gold" ]; then
    echo "ERROR: File $ortho_gold does not exist."
    exit 1;
fi

rm -fv "$ortho.aux.xml"
rm -fv "$ortho_gold.aux.xml"

cmp_stats.sh $ortho $ortho_gold
gdalinfo -stats $ortho | grep -v Files | grep -v -i tif > run/ortho.txt
gdalinfo -stats $ortho_gold | grep -v Files | grep -v -i tif > gold/ortho.txt

diff=$(diff run/ortho.txt gold/ortho.txt)
cat run/ortho.txt

rm -f run/ortho.txt gold/ortho.txt

echo ortho diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

# Check the state files
for f in run/ba/run-FC21B0004011_11224024300F1E.adjusted_state.json \
         run/ba/run-FC21B0004012_11224030401F1E.adjusted_state.json \
         run/ba_state/run-run-FC21B0004011_11224024300F1E.adjusted_state.json \
         run/ba_state/run-run-FC21B0004012_11224030401F1E.adjusted_state.json; do 

        g=${f/run\//gold\/}
        echo $f $g;
        if [ ! -f "$f" ] || [ ! -f "$g"  ]; then
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

