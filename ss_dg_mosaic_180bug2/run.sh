#!/bin/bash

set -x verbose
rm -rfv run

dg_mosaic --verbose ../data/*10300100346A4B00*ntf --skip-tif-gen --output-prefix run/run




