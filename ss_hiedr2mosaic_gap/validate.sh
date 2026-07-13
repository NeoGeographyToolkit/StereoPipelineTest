#!/bin/bash

file=run/output.txt

if [ ! -s "$file" ]; then
  echo "ERROR: $file is missing or empty."
  exit 1
fi

# A KeyError from a missing CCD must not appear.
if grep -q "KeyError" "$file"; then
  echo "ERROR: hiedr2mosaic crashed with a KeyError on a missing CCD."
  exit 1
fi

# Check that the pipeline steps still appear despite the gap.
for step in hi2isis hical histitch spiceinit spicefit noproj hijitreg handmos cubenorm; do
  if ! grep -q "$step" "$file"; then
    echo "ERROR: Expected step '$step' not found in output."
    exit 1
  fi
done

# Check that the script finished successfully.
if ! grep -q "Finished" "$file"; then
  echo "ERROR: Did not find 'Finished' in output."
  exit 1
fi

echo Validation succeeded
exit 0
