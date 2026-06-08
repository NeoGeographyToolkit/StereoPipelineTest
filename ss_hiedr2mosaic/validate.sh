#!/bin/bash

file=run/output.txt

if [ ! -s "$file" ]; then
  echo "ERROR: $file is missing or empty."
  exit 1
fi

# Check that all major pipeline steps appear in the output
for step in hi2isis hical histitch spiceinit spicefit noproj hijitreg handmos cubenorm; do
  if ! grep -q "$step" "$file"; then
    echo "ERROR: Expected step '$step' not found in output."
    exit 1
  fi
done

# Check that the script finished successfully
if ! grep -q "Finished" "$file"; then
  echo "ERROR: Did not find 'Finished' in output."
  exit 1
fi

echo Validation succeeded
exit 0
