#!/bin/bash

# In this testcase the various xml files have different pitches. We put a bugfix for that.

set -x verbose
rm -rfv run

aster2asp ../data/aster -o run/run


