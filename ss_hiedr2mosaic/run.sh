#!/bin/bash

set -x verbose
rm -rfv run
rm -rfv *cub

hiedr2mosaic.py ../data/ESP_029421_2300_RED*IMG

# TODO: Modify hiedr2mosaic.py to make its outputs go to any directory
mkdir -p run
mv ESP_029421_2300_RED.mos_hijitreged.norm.cub run

