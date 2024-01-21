#!/bin/bash

set -x verbose
rm -rfv run

dg_mosaic --verbose ../data/WV01_11JAN131652222-P1BS-10200100104A0300.tif ../data/WV01_11JAN131652231-P1BS-10200100104A0300.tif --rpc-penalty-weight 0.5 --reduce-percent 33 --skip-tif-gen --output-prefix run/run --verbose

