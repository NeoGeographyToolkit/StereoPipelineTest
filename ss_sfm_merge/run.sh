#!/bin/bash

set -x verbose
rm -rfv run

# Split
sfm_submap -input_map ../data/norig.nvm -image_list ../data/norig_nvm_list1.txt -output_map run/submap1.nvm
sfm_submap -input_map ../data/norig.nvm -image_list ../data/norig_nvm_list2.txt -output_map run/submap2.nvm

# Then merge
sfm_merge --rig_config ../data/norig_config.txt run/submap1.nvm run/submap2.nvm -num_image_overlaps_at_endpoints 4 -output_map run/merged.map -num_threads 1 

