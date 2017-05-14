#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust ../data/left_mars_rpc.tif ../data/right_mars_rpc.tif ../data/left_mars_rpc.xml ../data/right_mars_rpc.xml -o run/run -t rpc --datum mars

