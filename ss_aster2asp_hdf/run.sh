#!/bin/bash

# Test aster2asp with hdf input

set -x verbose
rm -rfv run

aster2asp ../data/AST_L1A_00404012022185436_20250920182851.hdf -o run/run

