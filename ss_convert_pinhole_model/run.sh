#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

convert_pinhole_model ../data/test_model.tsai --output-type RPC -o run/run-rpc.tsai --image-size "7391 7397" --rpc-degree 2

