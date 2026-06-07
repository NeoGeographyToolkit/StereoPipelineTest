#!/bin/bash

# CLOUD-MAC TEST: one of the small subset of tests that also run on Mac ARM64 and
# Linux ARM in the cloud (GitHub Actions, see .github/workflows in StereoPipeline).
# This subset is bundled into the StereoPipelineTest.tar release asset (tag 0.0.1).
# If that small tarball is ever lost, the cloud Mac/ARM suite can be rebuilt by
# collecting every test in this repo that carries this CLOUD-MAC TEST marker.

set -x verbose
rm -rfv run

mapproject ../data/Copernicus_DSM.tif ../data/basic_panchromatic.tif run/run-RPC.tif
