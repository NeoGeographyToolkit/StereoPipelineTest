#!/bin/bash

# Compare the alignment transforms against the gold results. The COPC cloud is
# the second one, so run-transform-1.txt exercises the COPC read path.
for file in run/run-transform-0.txt run/run-transform-1.txt; do

  gold=gold/$(basename $file)

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1
  fi
  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1
  fi

  diff=$(diff $file $gold | head -n 50)
  echo "Comparing $file with $gold, diff is $diff"
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi
done

echo Validation succeeded
exit 0
