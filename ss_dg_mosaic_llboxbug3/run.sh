#!/bin/bash

set -x verbose
rm -rfv run

dg_mosaic --verbose ../data/W*10300100208CF100.ntf --skip-tif-gen --output-prefix run/run



