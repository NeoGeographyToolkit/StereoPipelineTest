#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

hiedr2mosaic.py --dry-run ../data/ESP_029421_2300_RED*IMG \
  > run/output.txt 2>&1
