#!/bin/bash

set -x verbose
rm -rfv run

point2las --ecef ../data/ref-PC.tif --output-prefix run/run-LAS

