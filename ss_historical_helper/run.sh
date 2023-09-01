#!/bin/bash

set -x verbose
rm -rfv run

historical_helper.py --interest-points '4523 1506  114956 1450  114956 9355  4453 9408' rotate-crop --input-path ../data/left.tif --output-path run/run.tif --convert-path $HOME/miniconda3/envs/imagemagick/bin/convert

