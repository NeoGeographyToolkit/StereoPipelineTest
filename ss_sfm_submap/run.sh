#!/bin/bash

set -x verbose
rm -rfv run

sfm_submap -input_map ../data/cameras.nvm -output_map run/submap.nvm          \
  ../data/rig_calibrator_example_3_cameras/rig_input/haz_cam/1637278330.2962022.tif \
  ../data/rig_calibrator_example_3_cameras/rig_input/sci_cam/1637278316.7570000.tif
