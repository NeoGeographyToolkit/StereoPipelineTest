#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

convert_pinhole_model ../data/DMS_20171029_183704_02500.tif ../data/DMS_20171029_183704_02500.tsai --output-type RPC --sample-spacing 50 -o run/DMS_20171029_183704_02500_RPC.tsai


