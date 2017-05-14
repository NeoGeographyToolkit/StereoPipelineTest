#!/bin/bash

set -x verbose
rm -rfv run

orbitviz ../data/AS15-M-1131.lev1.cub ../data/AS15-M-1132.lev1.cub ../data/AS15-M-1133.lev1.cub -r D_MOON -o run/run.kml --write-csv
