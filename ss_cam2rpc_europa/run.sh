#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Issue #261: cam2rpc must save the body's datum into the RPC file (as WKT)
# so stereo and mapproject can recover it later. Here the body is Europa
# (sphere of radius 1,560,800 m), which has no standard datum name, so the
# datum is supplied two ways: a WKT projection string and explicit semi-axes.
# The camera is the Mars cam2rpc.tsai with its center radially scaled to sit
# 5 km above the Europa datum, so the geometry is self-consistent.

llr="--lon-lat-range 141.549246 34.199048 141.564853 34.231815 --height-range -500 1500 --num-samples 30"

# Path 1: datum from a WKT projection string (--t_srs)
cam2rpc --t_srs ../data/europa.wkt ../data/cam2rpc.tif ../data/cam2rpc_europa.tsai run/eur_tsrs.xml $llr

# Path 2: datum from explicit semi-major and semi-minor axes (generic, any body)
cam2rpc --semi-major-axis 1560800 --semi-minor-axis 1560800 ../data/cam2rpc.tif ../data/cam2rpc_europa.tsai run/eur_axes.xml $llr

# Confirm the generated RPC reproduces the input pinhole camera. This also
# exercises reading the datum back from the RPC file.
cam_test --session1 pinhole --session2 rpc --image ../data/cam2rpc.tif --cam1 ../data/cam2rpc_europa.tsai --cam2 run/eur_tsrs.xml --height-above-datum 0 > run/cam_test_tsrs.txt 2>&1
cam_test --session1 pinhole --session2 rpc --image ../data/cam2rpc.tif --cam1 ../data/cam2rpc_europa.tsai --cam2 run/eur_axes.xml --height-above-datum 0 > run/cam_test_axes.txt 2>&1
