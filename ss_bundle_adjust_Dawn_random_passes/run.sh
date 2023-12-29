#!/bin/bash

set -x verbose
rm -rfv run

# Run with 2 random passes 
bundle_adjust                                \
    ../data/FC21B0004011_11224024300F1E.cub  \
    ../data/FC21B0004012_11224030401F1E.cub  \
    ../data/FC21B0004011_11224024300F1E.json \
    ../data/FC21B0004012_11224030401F1E.json \
    --threads 1                              \
    --num-passes 1                           \
    --num-random-passes 2                    \
    --num-iterations 5                       \
    -o run/run
