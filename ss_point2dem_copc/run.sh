#!/bin/bash

set -x verbose
rm -rfv run

point2dem --tr 10 ../data/autzen-classified.copc.laz -o run/run --copc-win 636400 852260 638180 849990

