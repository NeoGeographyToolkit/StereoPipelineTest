#!/bin/bash
export PATH=../bin:$PATH

# Print any diff
../bin/max_err.pl run/run.txt gold/run.txt
ans=$?
if [ "$ans" -ne 0 ]; then
  echo Validation failed
  exit 1
fi

# Evaluate the diff with tolerance
ans=$(../bin/max_err.pl run/run.txt gold/run.txt 1e-9)
if [ "$ans" -eq 0 ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
