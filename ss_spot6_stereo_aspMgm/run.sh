#!/bin/bash

# SPOT 6 stereo test using synthetic SPOT 6 cameras derived from
# Pleiades NEO data.
#
# Camera provenance:
#   The DIM_SYNTH_SPOT6_{LEFT,RIGHT}.XML files were created by
#   ~/bin/neo_to_synth_spot6.py, which takes a real Pleiades NEO DIM XML
#   and the real SPOT 6 ESA La Crau DIM XML as a template, and produces
#   a synthetic SPOT 6 XML with the NEO camera model numbers (ephemeris,
#   quaternions, look angles, image size) inside a SPOT 6 XML skeleton
#   (S6_SENSOR profile, DIMAP 2.12). The images are the NEO crops.
#
# To regenerate the synthetic cameras:
#   python ~/bin/neo_to_synth_spot6.py \
#     ../data/DIM_PNEO4_202304032140366_PAN_SEN_PWOI_000079416_1_2_F_1.XML \
#     ../data/DIM_SPOT6_P_202404211020526_SEN_6979210101.XML \
#     ../data/DIM_SYNTH_SPOT6_LEFT.XML
#   python ~/bin/neo_to_synth_spot6.py \
#     ../data/DIM_PNEO4_202304032140266_PAN_SEN_PWOI_000079416_1_2_F_1.XML \
#     ../data/DIM_SPOT6_P_202404211020526_SEN_6979210101.XML \
#     ../data/DIM_SYNTH_SPOT6_RIGHT.XML

set -x verbose
rm -rfv run

parallel_stereo --stereo-algorithm asp_mgm --subpixel-mode 9 \
  --left-image-crop-win 0 0 888 730                          \
  --right-image-crop-win 0 0 800 800                         \
  ../data/IMG_PNEO4_202304032140366_PAN_SEN_PWOI_000079416_1_2_F_1_P_R1C1_crop.tif \
  ../data/IMG_PNEO4_202304032140266_PAN_SEN_PWOI_000079416_1_2_F_1_P_R1C1_crop.tif \
  ../data/DIM_SYNTH_SPOT6_LEFT.XML  \
  ../data/DIM_SYNTH_SPOT6_RIGHT.XML \
  run/run

point2dem --stereographic --proj-lon 212.246 --proj-lat 64.897 \
  --errorimage run/run-PC.tif
