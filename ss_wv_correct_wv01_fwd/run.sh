#!/bin/bash

set -x verbose
rm -rfv run

# Can do multiple output types
for ot in Byte UInt16 Int16 UInt32 Int32 Float32; do
	wv_correct ../data/WV01_11JUN151443020-P1BS-1020010013B10800_crop3.tif ../data/WV01_11JUN151443020-P1BS-1020010013B10800.xml run/run_${ot}.tif --ot $ot
done



