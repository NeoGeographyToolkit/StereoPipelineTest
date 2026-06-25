#!/bin/bash
source ../bin/setup_env.sh

file=run/run-DEM.tif
gold=gold/$(basename $file)

# If sparse_disp could not run (for example the bundled scipy or gdal are
# missing), stereo fails, no DEM is produced, and this fails.
if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist. stereo / sparse_disp failed."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

# Remove cached stats
rm -fv "$file.aux.xml"
rm -fv "$gold.aux.xml"

gdalinfo -stats $file | grep -v Files | grep -v -i tif | grep -i -v minimum > run/run.txt
gdalinfo -stats $gold | grep -v Files | grep -v -i tif | grep -i -v minimum > gold/run.txt
cat run/run.txt

# Tolerant comparison. The sparse_disp seed drifts across platforms: the DEM
# mean matches closely but the tails (stddev, min, max) can differ by ~10%
# (e.g. arm-Linux vs arm-Mac), so allow a loose relative error.
ans=$(../bin/max_err.pl run/run.txt gold/run.txt 2e-1)
rm -f run/run.txt gold/run.txt

if [ "$ans" != "1" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
