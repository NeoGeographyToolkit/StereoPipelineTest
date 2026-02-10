#!/bin/bash

set -x verbose
rm -rfv run

mkdir -p run

ipmatch --merge-match-files \
  ../data/sift-left_sub16__right_sub16.match \
  ../data/orb-left_sub16__right_sub16.match  \
  run/merged-left_sub16__right_sub16.match

ipmatch --binary-to-txt \
  ../data/sift-left_sub16__right_sub16.match \
  run/sift-left_sub16__right_sub16.txt

ipmatch --txt-to-binary \
  run/sift-left_sub16__right_sub16.txt \
  run/sift-left_sub16__right_sub16.match
