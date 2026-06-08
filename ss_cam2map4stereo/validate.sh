#!/bin/bash

file=run/output.txt

if [ ! -s "$file" ]; then
  echo "ERROR: $file is missing or empty."
  exit 1
fi

# Check that camrange ran on both images
count=$(grep -c "Running camrange" "$file")
if [ "$count" -lt 2 ]; then
  echo "ERROR: Expected 2 camrange calls, found $count."
  exit 1
fi

# Check that two cam2map commands were produced
count=$(grep -c "^cam2map " "$file")
if [ "$count" -lt 2 ]; then
  echo "ERROR: Expected 2 cam2map commands, found $count."
  exit 1
fi

# Check that the script finished successfully
if ! grep -q "Finished" "$file"; then
  echo "ERROR: Did not find 'Finished' in output."
  exit 1
fi

echo Validation succeeded
exit 0
