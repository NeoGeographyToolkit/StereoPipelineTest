#!/bin/bash

set -x verbose
rm -rfv run
rm -rfv *cub 

hiedr2mosaic.py ../data/ESP_029421_2300_RED*IMG 


