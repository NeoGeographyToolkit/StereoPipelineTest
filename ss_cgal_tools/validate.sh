#!/bin/bash

pass=true

for f in rm.ply smooth.ply filled.ply simple.ply; do
  file=run/$f
  gold=gold/$f

  if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    pass=false
    continue
  fi

  if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    pass=false
    continue
  fi

  diff=$(cmp "$file" "$gold" 2>&1)
  if [ "$diff" != "" ]; then
    echo "FAILED: $f differs from gold."
    pass=false
  else
    echo "PASSED: $f"
  fi
done

if [ "$pass" = true ]; then
  echo "Validation succeeded"
  exit 0
else
  echo "Validation failed"
  exit 1
fi
