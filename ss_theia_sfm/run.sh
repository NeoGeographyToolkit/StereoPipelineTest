#!/bin/bash

set -x verbose
rm -rfv run

# Test theia with sensor list
theia_sfm --rig_config ../data/rig_sensor_list/rig_config.txt     \
  --image_sensor_list ../data/rig_sensor_list/rig_sensor_list.txt \
  --theia_flags ../data/theia_flags.txt                           \
  --out_dir run

# Wipe the matches files, as they take a lot of space
rm -rfv */matches
