#!/bin/bash
source ../bin/setup_env.sh

# Stage 1: isd_generate must have produced a CSM ISD for each cropped cube.
for f in run/M074289249SE_crop.json run/M074296291SE_crop.json; do
    if [ ! -s "$f" ]; then
        echo "ERROR: ISD $f missing or empty (isd_generate stage failed)."
        exit 1
    fi
done

# Stage 2: bundle_adjust must have produced an adjusted CSM state per camera.
for f in run/ba/run-M074289249SE_crop.adjusted_state.json \
         run/ba/run-M074296291SE_crop.adjusted_state.json; do
    if [ ! -s "$f" ]; then
        echo "ERROR: bundle_adjust output $f missing (bundle_adjust stage failed)."
        exit 1
    fi
done

# Stage 3: the stereo DEM must match the gold.
file=run/stereo/run-DEM.tif
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

echo Validation succeeded
exit 0
