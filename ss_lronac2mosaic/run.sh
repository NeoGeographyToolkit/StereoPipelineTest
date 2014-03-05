#!/bin/bash

set -x verbose
rm -rfv run

lronac2mosaic.py -o run -c 4000 ../data/M120168714LE.IMG ../data/M120168714RE.IMG

