#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

cam_test --session1 dg --session2 dg --test-error-propagation --image ../data/grand_mesa_WV03_left_crop.tif --cam1 ../data/grand_mesa_WV03_left.xml --cam2 ../data/grand_mesa_WV03_right.xml --bundle-adjust-prefix ../data/ba_grand_mesa/run |tee run/run-out.txt

