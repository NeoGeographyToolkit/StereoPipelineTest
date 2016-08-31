#!/bin/bash

set -x verbose
rm -rfv run

geodiff --csv-format '1:lon 2:lat 3:radius_km'  ../data/dem5.tif ../data/lola.csv -o run/run



