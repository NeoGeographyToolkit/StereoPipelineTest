#!/bin/bash

set -x verbose
rm -rfv run

# Jitter solve with GCP, GCP outlier filtering, and robust GCP loss
jitter_solve                                          \
  --threads 1                                         \
  --num-iterations 2                                  \
  --num-passes 2                                      \
  --max-gcp-reproj-err 5                              \
  --gcp-robust-threshold 3                            \
  ../data/B17_016219_1978_XN_17N282W.8bit.cub         \
  ../data/B17_016219_1978_XN_17N282W.8bit.json        \
  ../data/B17_016219_1978_XN_17N282W.8bit.gcp         \
  -o run/run
