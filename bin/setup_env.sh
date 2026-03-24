#!/bin/bash

# Source this from validate.sh to set up PATH and check required tools.
# Exits with status 1 if any required tool is missing.

export PATH=../bin:$PATH

if ! which gdalinfo > /dev/null 2>&1; then
  echo "ERROR: gdalinfo not found on PATH. Cannot validate."
  exit 1
fi

if ! which cmp_stats.sh > /dev/null 2>&1; then
  echo "ERROR: cmp_stats.sh not found on PATH. Cannot validate."
  exit 1
fi
