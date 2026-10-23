#!/bin/bash
source ../bin/setup_env.sh

# The output of mosaicking one DEM must equal the input DEM, since the blending
# weight is positive and the weighted average is value*w/w = value. Compare the
# output to the input copy kept by run.sh, on grid and data fields. The writer
# normalizes the projection name (for example "Geographic Coordinate System" to
# "GCS_MOON") for the same datum, so the projection text is not compared.
file=run/run-tile-0.tif
ref=run/input.tif

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$ref" ]; then
    echo "ERROR: File $ref does not exist."
    exit 1;
fi

# Remove cached xmls
rm -fv "$file.aux.xml"
rm -fv "$ref.aux.xml"

# Pixel-value comparison (prints the max error, which must be zero for identity).
cmp_stats.sh $file $ref

# Grid and statistics must match exactly. The projection name is normalized by
# the writer, so compare size, origin, pixel size, statistics, and no-data only.
fields='Size is|Pixel Size|^Origin|STATISTICS_|NoData Value'
gdalinfo -stats $file | grep -E "$fields" > run/run.txt
gdalinfo -stats $ref  | grep -E "$fields" > run/ref.txt

diff=$(diff run/run.txt run/ref.txt)
cat run/run.txt

rm -f run/run.txt run/ref.txt

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
