#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

otsu_threshold ../data/left_bathy_b7.tif |tee run/run-otsu.txt 

