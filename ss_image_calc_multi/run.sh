#!/bin/bash

set -x verbose
rm -rfv run

# Test operations that take in multiple arguments, such as min()
image_calc -c \
 "2.0 * min(var_0, var_1, 7.0) +
  3.0 * max(var_0, 100, var_1) +
  4.0 * lt(var_1, 50, 1, 0) + 
  5.0 * gt(var_0, 100, 2, 0) + 
  6.0 * lte(var_1, 200, 4, 1) + 
  7.0 * gte(var_0, 50, 10, 0) + 
  8.0 * eq(var_1, 128, 1, 0)" \
  ../data/dem1_10pct.tif ../data/dem1_10pct.tif -o run/output.tif

