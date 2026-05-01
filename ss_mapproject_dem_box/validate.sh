#!/bin/bash
source ../bin/setup_env.sh

out=run/run.tif
dem=../data/dem_grid_aligned.tif

if [ ! -e "$out" ]; then
    echo "ERROR: File $out does not exist."
    exit 1
fi

# Extract Size, Origin, Pixel Size from gdalinfo. These three lines fully
# define the output grid; if the auto-bbox snap is correct they must match
# the DEM's, since DEM and output share projection and tr, and the DEM is
# aligned to the same pixel-center grid the output uses.
keys='^Size is|^Origin|^Pixel Size'

out_grid=$(gdalinfo "$out" | grep -E "$keys")
dem_grid=$(gdalinfo "$dem" | grep -E "$keys")

echo "DEM grid:"
echo "$dem_grid"
echo "Output grid:"
echo "$out_grid"

if [ "$out_grid" != "$dem_grid" ]; then
    echo "Validation failed: output grid does not match DEM grid"
    diff <(echo "$dem_grid") <(echo "$out_grid")
    exit 1
fi

echo "Validation succeeded"
exit 0
