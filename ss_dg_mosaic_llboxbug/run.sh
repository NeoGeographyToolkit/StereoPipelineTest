#!/bin/bash

set -x verbose
rm -rfv run

dg_mosaic --verbose ../data/*WV01_12JUN301516*tif --skip-tif-gen --output-prefix run/run



