#!/bin/bash
# CLOUD-MAC TEST

set -x verbose
rm -rfv run

mkdir run

# CaSSIS acceptance test. The vendor camera is a CSM model whose distortion is
# the TGO CaSSIS rational model (CSM distortion type 9). Loading it requires the
# CaSSIS-capable ale/usgscsm (ale::DistortionType::CASSIS). cam1 is the vendor
# CaSSIS model, cam2 is a transverse refit of it (same pose, distortion re-fit).
# A small ballpark pixel diff confirms ASP loads and applies the CaSSIS
# distortion. A crash or huge diff means the ale/usgscsm in use lack CaSSIS.

cam_test --sample-rate 50 \
  --image ../data/cassis_frame_838849161_0.cub \
  --cam1 ../data/cassis_vendor_838849161_0.json \
  --cam2 ../data/cassis_refit_838849161_0.json \
  | grep -E "Min|Max|Median" > run/run-out.txt
