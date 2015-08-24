#!/bin/bash

set -x verbose
rm -rfv run

mkdir run
pansharp  ../data/smaller_gray_8.tif ../data/smaller_rgb_8.tif run/output.tif --threads 6

