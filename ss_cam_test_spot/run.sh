#!/bin/bash

# SPOT 1-4 (HRV) CSM linescan model self-consistency test.
# Three cameras spanning the HRV steering-mirror range: near-nadir (+2.2 deg),
# east look (+28.2 deg), and west look (-23.7 deg). The strongly off-nadir looks
# exercise the mirror-boresight and distortion handling. cam_test reads the image
# size from the .dim, so no image raster is needed.
#
# Data source: CNES SPOT World Heritage (regards.cnes.fr/user/swh), Badia,
# northeast Jordan, SPOT-1 HRV2 panchromatic, grid reference K122/J285, 1987.

set -x verbose
rm -rfv run
mkdir run

for cam in spot1_19870422 spot1_19870824 spot1_19870905; do
  echo "=== $cam ===" >> run/run-out.txt
  cam_test --session1 spot5 --session2 spot5 \
    --image ../data/$cam.dim \
    --cam1 ../data/$cam.dim \
    --cam2 ../data/$cam.dim \
    --sample-rate 100 \
    | grep -E "Min|Max|Median" >> run/run-out.txt
done
