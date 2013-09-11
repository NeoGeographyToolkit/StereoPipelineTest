#!/bin/bash

set -x verbose
rm -rfv run

dg_mosaic --verbose ../data/WV01_11JAN131652222-P1BS-10200100104A0300.r12.tif ../data/WV01_11JAN131652231-P1BS-10200100104A0300.r12.tif --reduce-percent 25 --preview --skip-rpc-gen --output-prefix run/run


