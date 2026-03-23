#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

input=../data/small_mesh.ply

rm_connected_components 10 1 \
  $input run/rm.ply

smoothe_mesh 3 0.0001 0 \
  run/rm.ply run/smooth.ply

fill_holes 0.8 100 \
  run/smooth.ply run/filled.ply

simplify_mesh 0.5 \
  run/filled.ply run/simple.ply
