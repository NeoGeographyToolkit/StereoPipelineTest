#!/bin/bash

set -x verbose
rm -rfv run

mkdir -p run

# Quan-Fry mode + weighted_mean wavelength (default)
refr_index --salinity 35 --temperature 20 --mode Quan-Fry \
  --wavelength-method weighted_mean \
  --spectral-response ../data/WV02_Green_spectral_response.txt > run/run.txt

# Parrish mode + weighted_mean wavelength
refr_index --salinity 35 --temperature 20 --mode Parrish \
  --wavelength-method weighted_mean \
  --spectral-response ../data/WV02_Green_spectral_response.txt >> run/run.txt

# Quan-Fry mode + peak_response wavelength
refr_index --salinity 35 --temperature 20 --mode Quan-Fry \
  --wavelength-method peak_response \
  --spectral-response ../data/WV02_Green_spectral_response.txt >> run/run.txt

# Parrish mode + peak_response wavelength
refr_index --salinity 35 --temperature 20 --mode Parrish \
  --wavelength-method peak_response \
  --spectral-response ../data/WV02_Green_spectral_response.txt >> run/run.txt

# Single wavelength (no spectral response) - Quan-Fry
refr_index --salinity 35 --temperature 20 --mode Quan-Fry \
  --wavelength 532 >> run/run.txt

# Single wavelength (no spectral response) - Parrish
refr_index --salinity 35 --temperature 20 --mode Parrish \
  --wavelength 532 >> run/run.txt

