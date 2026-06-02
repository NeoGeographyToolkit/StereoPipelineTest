#!/bin/bash
source ../bin/setup_env.sh

# Goal: with no --output-nodata-value and a float32 output, image_calc must use
# the clean type-aware default nodata -1e6, not the old -FLT_MAX (~-3.4e38),
# which is not exactly representable and prints with reduced precision.

nd=$(gdalinfo run/out_float.tif 2>/dev/null | grep -m1 'NoData Value' | sed 's/.*=//')
echo "output nodata = $nd"

ok=1
awk "BEGIN{exit !($nd == -1000000)}" \
  || { echo "FAIL: float32 output nodata is not -1e6 (got $nd)"; ok=0; }

if [ $ok -eq 1 ]; then
  echo "Validation succeeded"; exit 0
else
  echo "Validation failed"; exit 1
fi
