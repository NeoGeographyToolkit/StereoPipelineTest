#!/bin/bash

set -x verbose
rm -rfv run

dg_mosaic --verbose ../data/14JUN19185250*TIF --skip-tif-gen --output-prefix run/run



