#!/bin/bash

set -x verbose
rm -rfv run

point2las --compressed ../data/ref-PC.tif --output-prefix run/run-LAS

