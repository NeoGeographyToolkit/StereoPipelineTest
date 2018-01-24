#!/bin/bash

set -x verbose
rm -rfv run

# To do: When the clips are interchanged, the results are wrong!

# Can do multiple output types
for ot in Byte UInt16 Int16 UInt32 Int32 Float32; do
	dem_mosaic ../data/clip1_lonlat.tif ../data/clip2_utm.tif -o run/run_${ot}.tif --ot $ot
done


