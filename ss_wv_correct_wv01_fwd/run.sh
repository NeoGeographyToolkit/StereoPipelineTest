#!/bin/bash

set -x verbose
rm -rfv run

wv_correct ../data/WV01_11JUN151443020-P1BS-1020010013B10800_crop3.tif ../data/WV01_11JUN151443020-P1BS-1020010013B10800.xml run/run.tif

