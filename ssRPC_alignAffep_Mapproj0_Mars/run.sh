#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/left_mars_rpc.tif ../data/right_mars_rpc.tif ../data/left_mars_rpc.xml ../data/right_mars_rpc.xml run/run -t rpc --datum mars

point2dem run/run-PC.tif


