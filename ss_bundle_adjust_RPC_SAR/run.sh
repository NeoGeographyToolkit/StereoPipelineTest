#!/bin/bash

# Bundle adjust with Umbra SAR RPC cameras 

set -x verbose
rm -rfv run

bundle_adjust --threads 1 ../data/2024-08-08-02-33-49_UMBRA-05_GEC.tif ../data/2024-06-30-03-03-56_UMBRA-04_GEC.tif --clean-match-files-prefix ../data/umbra_sar_rpc/run -o run/run

