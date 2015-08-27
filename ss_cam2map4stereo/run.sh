#!/bin/bash

set -x verbose
rm -rfv run

cam2map4stereo.py ../data/M0100115_crop2.cub ../data/E0201461_crop2.cub --prefix run/run


