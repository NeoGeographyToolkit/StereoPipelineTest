#!/bin/bash

set -x verbose
rm -rfv run

mkdir -p run

# Test with Quan-Fry mode (default, but set explicitly)
refr_index --salinity 35 --temperature 20 --mode Quan-Fry \
  --spectral-response ../data/WV02_Green_spectral_response.txt > run/run.txt

# Test with Parrish mode (append to same file)
refr_index --salinity 35 --temperature 20 --mode Parrish \
  --spectral-response ../data/WV02_Green_spectral_response.txt >> run/run.txt

