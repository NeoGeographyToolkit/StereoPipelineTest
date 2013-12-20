#!/bin/bash

set -x verbose
rm -rfv run

wv_correct ../data/WV02_10OCT091530189-P1BS-1030010007898D00_crop.tif ../data/WV02_10OCT091530189-P1BS-1030010007898D00.xml run/run.tif

