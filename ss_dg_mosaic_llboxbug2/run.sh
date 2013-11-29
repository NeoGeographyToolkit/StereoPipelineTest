#!/bin/bash

set -x verbose
rm -rfv run

dg_mosaic --verbose ../data/W*1030010022828900.ntf --skip-tif-gen --output-prefix run/run



