#!/bin/bash

# Check that gdalinfo is available. Source this from validate.sh:
#   source ../bin/check_gdalinfo.sh

if ! command -v gdalinfo > /dev/null 2>&1; then
  echo "ERROR: gdalinfo not found in PATH"
  exit 1
fi
