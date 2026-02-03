#!/bin/bash

set -x verbose
rm -rfv run

# Test theia with sensor list
theia_sfm --rig-config ../data/rig_sensor_list/rig_config.txt     \
  --image-sensor-list ../data/rig_sensor_list/rig_sensor_list.txt \
  --theia-flags ../data/theia_flags.txt                           \
  --out-dir run

# Wipe the matches files, as they take a lot of space
rm -rfv */matches
