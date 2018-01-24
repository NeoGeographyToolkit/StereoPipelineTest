#!/bin/bash

set -x verbose
rm -rfv run

# Can do multiple output types
for ot in Byte UInt16 Int16 UInt32 Int32 Float32; do
	dg_mosaic --verbose ../data/WV01_11JAN131652222-P1BS-10200100104A0300.r12.tif ../data/WV01_11JAN131652231-P1BS-10200100104A0300.r12.tif --reduce-percent 25 --preview --skip-rpc-gen --output-prefix run/run_${ot} --ot $ot
done



