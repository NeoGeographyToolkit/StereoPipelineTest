#!/bin/bash

set -x verbose
rm -rfv run

# WV02 data generated starting with May 26, 2022 do not need a correction
wv_correct ../data/WV02_10OCT091530189-P1BS-1030010007898D00_crop.tif ../data/WV02_fake_2022-05-26.xml run/run.tif

