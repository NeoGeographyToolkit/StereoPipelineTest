#!/bin/bash

set -x verbose
rm -rfv run

mkdir -p run
refr_index --salinity 35 --temperature 20 --spectral-response ../data/WV02_Green_spectral_response.txt > run/run.txt

